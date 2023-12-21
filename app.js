const express = require('express');
const bodyParser = require('body-parser');
const { DynamoDBClient, PutItemCommand } = require('@aws-sdk/client-dynamodb');
const cors = require('cors');

const app = express();
const PORT = 3000;

app.use(bodyParser.json());
app.use(cors());

const dynamoDB = new DynamoDBClient({
    region: 'us-east-2',
});

const tableName = 'hellostaticwebhost';

app.post('/submit', async (req, res) => {
    const { username, phone } = req.body;

    console.log('Received data:', { username, phone });

    const params = {
        TableName: tableName,
        Item: {
            "username": { S: username },
            "phone": { S: phone },
        },
    };

    try {
        await dynamoDB.send(new PutItemCommand(params));
        console.log('Data stored successfully');
        res.json({ username });
    } catch (error) {
        console.error('Error storing data:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
