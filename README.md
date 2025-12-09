### **Hospital Events – Arquitectura Serverless en AWS**



#### Descripción

Sistema híbrido en AWS que procesa eventos hospitalarios (pacientes, citas, inventarios, facturación) usando API Gateway, Lambdas, SQS, DynamoDB y CloudWatch. El flujo desacopla productores y consumidores, asegurando escalabilidad, resiliencia y observabilidad.





###### Arquitectura

API Gateway: expone endpoints REST /pacientes, /citas, /inventarios, /facturacion.

Lambdas productores: reciben requests y envían mensajes a la cola SQS.

SQS (hospital-events-queue): cola central que desacopla productores y consumidores.

Lambda consumidor: procesa mensajes de SQS y los guarda en DynamoDB.

DynamoDB (hospital-events): almacena eventos con atributos id, servicio, payload, timestamp.

CloudWatch: logs, alarmas y dashboard centralizado.



Despliegue con Terraform

Inicializar Terraform:



!\[Init Lambda](sanavi-infra/lambdas/images/init.png)



Aplicar la infraestructura:





!\[Init Lambda](sanavi-infra/lambdas/images/apply.png)





Archivos principales:



lambdas-env.tf → definición de Lambdas y SQS.

dynamo.tf → tabla DynamoDB.

alarms.tf → alarmas de CloudWatch.

dashboard.tf → dashboard de métricas.





Pruebas end‑to‑end

Enviar request desde Postman:

!\[Init Lambda](sanavi-infra/lambdas/images/3.png)





Validar en DynamoDB (CLI)

!\[Init Lambda](sanavi-infra/lambdas/images/4.png)





Ejemplo de salida:

!\[Init Lambda](sanavi-infra/lambdas/images/5.png)





Revisar CloudWatch Logs:

!\[Init Lambda](sanavi-infra/lambdas/images/6.png)



Dashboard en CloudWatch: abrir HospitalEventsDashboard y validar métricas de Lambdas y DynamoDB.

#### 

#### Estimación de costos en producción

#### 

Lambda: ~2M invocaciones → $8 USD

SQS: ~2M mensajes → $0.80 USD

DynamoDB: ~1M lecturas + 500K escrituras → $25 USD

CloudWatch Logs + Alarms → $3 USD

Total mensual aproximado: $36–40 USD





##### diagrama de la arquitectura



!\[Init Lambda](sanavi-infra/lambdas/images/7.png)



