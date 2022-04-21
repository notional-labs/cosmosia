const express = require('express');
let bodyParser = require('body-parser');

let app = express();
// app.use(bodyParser.urlencoded({ extended: true }));
// app.use(bodyParser.json({ type: 'application/json'}));

app.use(express.static("./build"));

const port = process.env.PORT || 7749;
app.listen(port, () => console.log('Server listening on port ' + port));

