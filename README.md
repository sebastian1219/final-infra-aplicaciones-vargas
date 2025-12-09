🧾 Fases del laboratorio – Proyecto AWS EKS + Serverless

Fase 0 – Configuración base

Terraform inicializado (>= 1.6.0).



Provider AWS versión ~> 5.50.



Variables definidas:



aws\_region = us-east-1



project\_initials = JSV



env = dev



cluster\_role\_arn = arn:aws:iam::730335546358:role/c174285a4511470l11506634t1w730335-LabEksClusterRole-a7GGm8V2UeeU



node\_role\_arn = arn:aws:iam::730335546358:role/c174285a4511470l11506634t1w730335546-LabEksNodeRole-5CbQPh6hnInC



vpc\_id = vpc-09eba15796328f763



Cluster EKS creado con recursos nativos:



aws\_eks\_cluster (plano de control).



aws\_eks\_node\_group (nodos).



Compatibilidad de AZs: filtradas a us-east-1a, us-east-1b, us-east-1c.



Versión de Kubernetes: 1.29.



👉 Resultado: cluster etclusterJSV-dev operativo con 3 nodos t3.small.



Fase 1 – Networking y despliegue inicial

Validar acceso al cluster con aws eks update-kubeconfig.



Crear namespaces: frontend, backend, admin, web-test.



Desplegar NGINX de prueba en web-test con Service tipo LoadBalancer.



Validar acceso vía ELB externo.



Configurar NetworkPolicies para aislar tráfico (ejemplo: solo frontend puede hablar con backend).



👉 Resultado: cluster accesible, workloads iniciales corriendo, aislamiento básico aplicado.



Fase 2 – Microservicios backend

Desplegar servicios dummy:



pacientes



citas



inventarios



facturación



Organizar en namespaces (frontend, backend, admin).



Configurar Horizontal Pod Autoscaler (HPA) y Vertical Pod Autoscaler (VPA) para escalabilidad.



Validar con kubectl get hpa.



👉 Resultado: microservicios corriendo con escalabilidad automática.



Fase 3 – Serverless (Lambda + API Gateway + SQS)

Crear funciones Lambda con prefijo etfxnJSV-....



Ejemplo: etfxnJSV-citas-create.



Integrar con API Gateway (etapiJSV-hospital-dev).



Crear cola SQS para desacoplar eventos.



Probar invocación con curl o Invoke-RestMethod.



👉 Resultado: endpoints REST funcionando, Lambda procesando eventos, integración con SQS.



Fase 4 – Seguridad

TLS/SSL con ACM (si tu lab permite certificados).



IAM mínimo privilegio (roles ya definidos).



RBAC en Kubernetes.



Secrets en AWS Secrets Manager.



👉 Resultado: seguridad aplicada en plano de control y workloads.



Fase 5 – Observabilidad

CloudWatch Logs para Lambda y API Gateway.



Prometheus + Grafana (si tu lab permite).



Alarmas CloudWatch (ejemplo: errores Lambda > 5 en 5 min).



Troubleshooting con kubectl logs.



👉 Resultado: monitoreo activo y alarmas configuradas.



Fase 6 – CI/CD

Pipelines con terraform plan/apply.



Scripts: init.sh, apply.sh, destroy.sh.



Validación automática de formato y plan.



👉 Resultado: despliegues reproducibles y automatizados.



Fase 7 – Costos y presentación

Estimación con AWS Pricing Calculator:



EKS control plane ~72 USD/mes.



Nodos EC2 ~60 USD/mes.



RDS PostgreSQL ~120 USD/mes.



S3 + Glacier ~20 USD/mes.



Lambda + API Gateway ~20 USD/mes.



CloudWatch ~10 USD/mes.



Total aprox: 300 USD/mes → 3600 USD/año.



Presentación al cliente con diagrama y pruebas.



👉 Resultado: visión clara de costos y beneficios.



✅ Con esto tienes la ruta completa del laboratorio, desde la fase 0 (infra base) hasta la fase 7 (presentación final), todo alineado con tus roles, VPC y restricciones de laboratorio.

