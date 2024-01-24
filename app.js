// app.js backend
const express = require('express');
const bodyParser = require('body-parser');
const { DynamoDBClient, PutItemCommand, ScanCommand } = require('@aws-sdk/client-dynamodb');
const cors = require('cors');
const winston = require('winston');
const WinstonCloudWatch = require('winston-cloudwatch');

const app = express();
const PORT = 3000;

// Configure Winston logger
const logger = winston.createLogger({
    transports: [
        new winston.transports.Console(),
        new winston.transports.File({ filename: 'app.log' }),
        new WinstonCloudWatch({
            logGroupName: 'HostLogGroupName', 
            logStreamName: 'HostLogStreamName', 
            awsRegion: 'us-east-1', 
            messageFormatter: ({ level, message, meta }) => `[${level}] ${message} ${meta ? JSON.stringify(meta) : ''}`,
        }),
    ],
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()  
    ),
});

app.use(bodyParser.json());
app.use(cors());

const dynamoDB = new DynamoDBClient({
    region: 'us-east-1',
});

const tableName = 'test-web-infra';

// Submit data endpoint
app.post('/submit', async (req, res) => {
    try {
        const { username, phone } = req.body;
        logger.info('Received data:', { username, phone });

        const params = {
            TableName: tableName,
            Item: {
                "username": { S: username },
                "phone": { S: phone },
            },
        };

        await dynamoDB.send(new PutItemCommand(params));
        logger.info('Data stored successfully');
        res.json({ username });
    } catch (error) {
        logger.error('Error storing data:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

// View DB endpoint
app.get('/viewDb', async (req, res) => {
    try {
        const scanParams = {
            TableName: tableName,
        };
        const result = await dynamoDB.send(new ScanCommand(scanParams));
        const data = result.Items.map(item => ({
            username: item.username.S,
            phone: item.phone.S,
        }));
        res.json(data);
    } catch (error) {
        logger.error('Error fetching data from DynamoDB:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

// Server listen
app.listen(PORT, '0.0.0.0', () => {
    logger.info(`Server is running on http://localhost:${PORT}`);
});
