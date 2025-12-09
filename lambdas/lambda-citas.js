const { SQSClient, SendMessageCommand } = require("@aws-sdk/client-sqs");
const client = new SQSClient();

exports.handler = async (event) => {
  console.log("Evento recibido en CITAS:", event);

  try {
    const body = JSON.parse(event.body);

    const params = {
      QueueUrl: process.env.SQS_URL,
      MessageBody: JSON.stringify({
        servicio: "citas",
        payload: body
      }),
    };

    await client.send(new SendMessageCommand(params));
    console.log("Mensaje enviado a SQS:", params);

    return {
      statusCode: 200,
      body: JSON.stringify({
        servicio: "citas",
        mensaje: "Cita agendada y enviada a SQS",
        input: body
      }),
    };
  } catch (err) {
    console.error("Error enviando a SQS:", err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Fallo al enviar evento a SQS", detalle: String(err) }),
    };
  }
};

