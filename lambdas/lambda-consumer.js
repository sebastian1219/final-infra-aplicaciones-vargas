const { DynamoDBClient, PutItemCommand } = require("@aws-sdk/client-dynamodb");
const crypto = require("crypto");

const dynamo = new DynamoDBClient();

exports.handler = async (event) => {
  console.log("Mensajes recibidos desde SQS:", JSON.stringify(event, null, 2));

  for (const record of event.Records) {
    const body = JSON.parse(record.body);
    console.log("Procesando mensaje:", body);

    // Generar ID único sin dependencia externa
    const id = crypto.randomUUID();

    const params = {
      TableName: process.env.DYNAMO_TABLE,
      Item: {
        id:        { S: id },
        servicio:  { S: body.servicio },
        payload:   { S: JSON.stringify(body.payload) },
        timestamp: { S: new Date().toISOString() }
      }
    };

    try {
      await dynamo.send(new PutItemCommand(params));
      console.log("Guardado en DynamoDB:", params.Item);
    } catch (err) {
      console.error("Error guardando en DynamoDB:", err);
    }
  }

  return {
    statusCode: 200,
    body: JSON.stringify({ mensaje: "Mensajes procesados y almacenados en DynamoDB" }),
  };
};

