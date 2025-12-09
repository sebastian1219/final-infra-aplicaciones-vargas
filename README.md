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



!\[Init Lambda](lambdas/images/init.png)



Aplicar la infraestructura:





!\[Apply Terraform](lambdas/images/apply.png)





Archivos principales:



lambdas-env.tf → definición de Lambdas y SQS.

dynamo.tf → tabla DynamoDB.

alarms.tf → alarmas de CloudWatch.

dashboard.tf → dashboard de métricas.





Pruebas end‑to‑end

Enviar request desde Postman:

!\[Postman Request](lambdas/images/3.png)





Validar en DynamoDB (CLI)

!\[DynamoDB CLI](lambdas/images/4.png)





Ejemplo de salida:

!\[DynamoDB Output](lambdas/images/5.png)



Revisar CloudWatch Logs:

!\[CloudWatch Logs](lambdas/images/6.png)



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



!\[Architecture Diagram](lambdas/images/7.png)





flowchart LR

&nbsp;   A\[API Gateway] --> B1\[Lambda Pacientes]

&nbsp;   A --> B2\[Lambda Citas]

&nbsp;   A --> B3\[Lambda Inventarios]

&nbsp;   A --> B4\[Lambda Facturación]



&nbsp;   B1 --> C\[SQS hospital-events-queue]

&nbsp;   B2 --> C

&nbsp;   B3 --> C

&nbsp;   B4 --> C



&nbsp;   C --> D\[Lambda Consumidor]

&nbsp;   D --> E\[DynamoDB hospital-events]

&nbsp;   E --> F\[CloudWatch Dashboard \& Alarms]



sequenceDiagram

&nbsp;   participant Dev as Desarrollador

&nbsp;   participant TF as Terraform

&nbsp;   participant AWS as AWS Infra



&nbsp;   Dev->>TF: terraform init

&nbsp;   TF->>AWS: Inicializa proveedores

&nbsp;   Dev->>TF: terraform apply

&nbsp;   TF->>AWS: Crea recursos (API Gateway, Lambdas, SQS, DynamoDB, CloudWatch)

&nbsp;   AWS-->>Dev: Infraestructura desplegada



sequenceDiagram

&nbsp;   participant User as Postman

&nbsp;   participant API as API Gateway

&nbsp;   participant Lambda as Lambda Productor

&nbsp;   participant SQS as SQS Queue

&nbsp;   participant Consumer as Lambda Consumidor

&nbsp;   participant DB as DynamoDB

&nbsp;   participant CW as CloudWatch



&nbsp;   User->>API: POST /pacientes

&nbsp;   API->>Lambda: Invoca función

&nbsp;   Lambda->>SQS: Envía mensaje

&nbsp;   SQS->>Consumer: Dispara evento

&nbsp;   Consumer->>DB: Guarda registro

&nbsp;   DB-->>User: Datos disponibles

&nbsp;   Consumer->>CW: Logs y métricas



























