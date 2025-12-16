### **Hospital Events – Arquitectura Serverless en AWS**





!\[Init Terraform](images/init.png)

!\[Apply Terraform](images/apply.png)

!\[Postman Request](images/3.png)

!\[DynamoDB CLI](images/4.png)

!\[DynamoDB Output](images/5.png)

!\[CloudWatch Logs](images/6.png)

!\[Architecture Diagram](images/7.png)







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

!\[Init Terraform](https://github.com/sebastian1219/final-infra-aplicaciones-vargas/blob/master/images/init.png?raw=true)



Aplicar la infraestructura:





!\[Apply Terraform](https://github.com/sebastian1219/final-infra-aplicaciones-vargas/blob/master/images/apply.png?raw=true)





Archivos principales:



lambdas-env.tf → definición de Lambdas y SQS.

dynamo.tf → tabla DynamoDB.

alarms.tf → alarmas de CloudWatch.

dashboard.tf → dashboard de métricas.





Pruebas end‑to‑end

Enviar request desde Postman:

!\[Postman Request](https://github.com/sebastian1219/final-infra-aplicaciones-vargas/blob/master/images/3.png?raw=true)





Validar en DynamoDB (CLI)

!\[DynamoDB CLI](https://github.com/sebastian1219/final-infra-aplicaciones-vargas/blob/master/images/4.png?raw=true)



Ejemplo de salida:

!\[DynamoDB Output](https://github.com/sebastian1219/final-infra-aplicaciones-vargas/blob/master/images/5.png?raw=true)





Revisar CloudWatch Logs:

!\[CloudWatch Logs](https://github.com/sebastian1219/final-infra-aplicaciones-vargas/blob/master/images/6.png?raw=true)



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



!\[Architecture Diagram](https://github.com/sebastian1219/final-infra-aplicaciones-vargas/blob/master/images/7.png?raw=true)



























\# Hospital Events – Arquitectura Serverless en AWS



!\[Init Terraform](images/init.png)

!\[Apply Terraform](images/apply.png)

!\[Postman Request](images/3.png)

!\[DynamoDB CLI](images/4.png)

!\[DynamoDB Output](images/5.png)

!\[CloudWatch Logs](images/6.png)

!\[Architecture Diagram](images/7.png)



\## Descripción

Sistema híbrido en AWS que procesa eventos hospitalarios (pacientes, citas, inventarios, facturación) usando API Gateway, Lambdas, SQS, DynamoDB y CloudWatch. El flujo desacopla productores y consumidores, asegurando escalabilidad, resiliencia y observabilidad.



\## Arquitectura

\- \*\*API Gateway\*\*: expone endpoints REST `/pacientes`, `/citas`, `/inventarios`, `/facturacion`.

\- \*\*Lambdas productores\*\*: reciben requests y envían mensajes a la cola SQS.

\- \*\*SQS (hospital-events-queue)\*\*: cola central que desacopla productores y consumidores.

\- \*\*Lambda consumidor\*\*: procesa mensajes de SQS y los guarda en DynamoDB.

\- \*\*DynamoDB (hospital-events)\*\*: almacena eventos con atributos `id`, `servicio`, `payload`, `timestamp`.

\- \*\*CloudWatch\*\*: logs, alarmas y dashboard centralizado.



\## Despliegue con Terraform

Inicializar Terraform:



!\[Init Terraform](images/init.png)



Aplicar la infraestructura:



!\[Apply Terraform](images/apply.png)



Archivos principales:

\- `lambdas-env.tf` → definición de Lambdas y SQS.

\- `dynamo.tf` → tabla DynamoDB.

\- `alarms.tf` → alarmas de CloudWatch.

\- `dashboard.tf` → dashboard de métricas.



\## Pruebas end‑to‑end

Enviar request desde Postman:



!\[Postman Request](images/3.png)



Validar en DynamoDB (CLI):



!\[DynamoDB CLI](images/4.png)



Ejemplo de salida:



!\[DynamoDB Output](images/5.png)



Revisar CloudWatch Logs:



!\[CloudWatch Logs](images/6.png)



Dashboard en CloudWatch: abrir `HospitalEventsDashboard` y validar métricas de Lambdas y DynamoDB.



\## Estimación de costos en producción

\- Lambda: ~2M invocaciones → $8 USD  

\- SQS: ~2M mensajes → $0.80 USD  

\- DynamoDB: ~1M lecturas + 500K escrituras → $25 USD  

\- CloudWatch Logs + Alarms → $3 USD  



\*\*Total mensual aproximado: $36–40 USD\*\*



