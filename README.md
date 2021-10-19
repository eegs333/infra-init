# infra-init

### Requisitos
* Terraform
* AWS Cli
* Ansible


### Instruciones

1. Clonar el repositorio
~~~
git clone https://github.com/eegs333/infra-init.git
~~~
2. Crear la infraestructura
~~~
cd infra-init
terraform init
terraform apply
~~~
2. Configurar jenkins
~~~
ansible-playbook playbook.yml
~~~
3. Ingresar a jenkins
Verificar con el siguiente comando la ip de jenkins y entrar a la consola con las credenciales user: admin pass: admin por el puerto 8080
~~~
terraform output
http://JenkinsServerInstance_IP:8080
~~~

4. Ejecutar el job "pipeline"

5. Verificar la ip del api e ingresar por el puerto 8000
~~~
terraform output
http://AppServerInstance_IP:8000/admin/
~~~

