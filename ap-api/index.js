require('dotenv-safe').config({ allowEmptyValues: true });
const TYPE = ['Body Movement', 'Snore', 'Cough', 'None'];
const express = require('express');
const compression = require('compression');
const fileUpload = require('express-fileupload');

const app = express();
app.set('port', process.env.PORT || 3000);

app.use(require('cors')());
app.use(require('morgan')('dev'));

app.use(compression());
app.use(fileUpload({ preserveExtension: true }));
app.use(express.urlencoded({ extended: false }));
app.use(express.json());
app.use(express.text());

app.get('/ping', (req, res) => res.status(200).send('pong'));
app.get('/testing', (req, res) => {
    function getRandomInt(int) {
        return Math.floor(Math.random() * int);
    }
    // const date = new Date(Date.now());
    const bodyMovement = getRandomInt(5); 
    const snore = getRandomInt(5); 
    const cough = getRandomInt(5); 

    return res.status(200).json({  bodyMovement, snore, cough });
});
app.get('/frameType', (req, res) => {
    return res.status(200).json({ type:  TYPE[Math.floor(Math.random() * 4)]});
});

const server = app.listen(app.get('port'), () => {console.log(`Server running on port ${app.get('port')}`)});

// console.log(express);

module.exports = server;
