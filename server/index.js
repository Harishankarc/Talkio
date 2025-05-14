const express = require('express');
const cors = require('cors');
const expressWs = require('express-ws');
const sql = require('sqlite3').verbose();

const app = express();
expressWs(app);

const db = new sql.Database('./database.db');

const queries = [
  `CREATE TABLE IF NOT EXISTS Contacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    recipent_email TEXT NOT NULL,
    recipent_name TEXT NOT NULL,
    from_email TEXT NOT NULL
  );`,
  `CREATE TABLE IF NOT EXISTS Messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sender_email TEXT NOT NULL,
    receiver_email TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL,
    time TEXT NOT NULL,
    seen BOOLEAN NOT NULL DEFAULT 0
  );`
];

db.serialize(() => {
  queries.forEach((q) => db.run(q));
});

// Store connected users by email
let users = {};

app.use(cors());
app.use(express.json());

// Add a new contact
app.post('/addcontacts', (req, res) => {
  const { recipent_email, recipent_name, from_email } = req.body;

  if (!recipent_email || !recipent_name || !from_email) {
    return res.status(400).json({ error: 'All fields are required.' });
  }

  const sql = 'INSERT INTO Contacts (recipent_email, recipent_name, from_email) VALUES (?, ?, ?)';
  db.run(sql, [recipent_email, recipent_name, from_email], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(200).json({ message: 'Contact added successfully' });
  });
});

// Get user's contacts
app.post('/getcontacts', (req, res) => {
  const { email } = req.body;

  if (!email) return res.status(400).json({ error: 'Email is required.' });

  const sql = 'SELECT * FROM Contacts WHERE from_email = ?';
  db.all(sql, [email], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(200).json(rows);
  });
});

app.ws('/chat', (ws, req) => {
  let currentUser = null;

  ws.on('message', (msg) => {
    console.log('Received message:', msg);
    try {
      const data = JSON.parse(msg);

      // Register user connection
      if (data.type === 'init') {
        currentUser = data.email;
        users[currentUser] = ws;
        console.log(`User connected: ${currentUser}`);


        // Send acknowledgment to client
        ws.send(JSON.stringify({ type: 'ack', message: 'Connection established', add : false }));

        const recipientEmail = data.recipent;
        if(recipientEmail){
          const historySQL = 'SELECT * FROM Messages WHERE (sender_email = ? AND receiver_email = ?) OR (sender_email = ? AND receiver_email = ?) ORDER BY id ASC';
          db.all(historySQL, [currentUser, recipientEmail, recipientEmail, currentUser], (err,data)=>{
            if(err) return console.log(err);
            ws.send(JSON.stringify({ type: 'history', history : data }));
          })
        }
        return;
      }

      // Handle message sending
      if (data.type === 'message') {
        const { from, to, message } = data;
        console.log(`Message from ${from} to ${to}: ${message}`); // Log the message being sent

        const now = new Date();
        const timeString = new Intl.DateTimeFormat('en-IN', {
          hour: '2-digit',
          minute: '2-digit',
          hour12: false,
          timeZone: 'Asia/Kolkata'
        }).format(now);
        // // Store message in the database (persistent storage)
        const insertMessageSQL = 'INSERT INTO Messages (sender_email, receiver_email, message, type, time, seen) VALUES (?, ?, ?, ?, ?, ?)';
        db.run(insertMessageSQL, [from, to, message, 'message', timeString, users[to] ? 1 : 0]);


        // Deliver the message if the recipient is online
        if (users[to]) {
          console.log(`Sending message to ${to} at time ${timeString}`);
          users[to].send(JSON.stringify({ from, message , timeString , seen : true }));
        } else {
          console.log(`User ${to} is offline. Message not delivered immediately.`);
        }
      }

      //handle photo msg
      if (data.type === 'photo') {
          const { from, to, message, time } = data;

          const insertPhotoSQL = `
            INSERT INTO Messages (sender_email, receiver_email, message, type, time, seen)
            VALUES (?, ?, ?, ?, ?, ?)
          `;
          db.run(insertPhotoSQL, [from, to, message, 'photo', time, users[to] ? 1 : 0]);

          if (users[to]) {
            users[to].send(JSON.stringify({
              type: 'photo',
              from,
              message, 
              time,
              seen: true
            }));
          } else {
            console.log(`User ${to} is offline. Photo message saved but not sent.`);
          }
          return;
      }


      //handle voice msg
      if (data.type === 'voice') {
        const { from, to, message, time, format } = data;

        const insertVoiceSQL = `
          INSERT INTO Messages (sender_email, receiver_email, message, type, time, seen)
          VALUES (?, ?, ?, ?, ?, ?)
        `;
        db.run(insertVoiceSQL, [from, to, message, 'voice', time, users[to] ? 1 : 0]);

        if (users[to]) {
          users[to].send(JSON.stringify({
            type: 'voice',
            from,
            message, // base64 audio
            time,
            format: format || 'm4a',
            seen: true
          }));
        } else {
          console.log(`User ${to} is offline. Voice message saved but not sent.`);
        }
        return;
      }

    } catch (err) {
      console.error('Error parsing message:', err);
    }
  });

  ws.on('close', () => {
    if (currentUser) {
      console.log(`User disconnected: ${currentUser}`);
      delete users[currentUser];
    }
  });
});


app.listen(3050, '0.0.0.0', () => {
  console.log('Server running on port 3050');
});
