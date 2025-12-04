<div align="center">

**o11-v4 Docker Deployment**

Uma aplicação Docker para executar o o11-v4 usando Node.js ou Python.
</div>

## Pré-requisitos

````markdown

- Aplicação em Docker testado no Ubuntu 22.04.
- Um endereço IP público ou domínio apontando para o seu servidor.

````

## Instalação
1. **Extraindo a imagem base**
   ```bash
   docker pull docker.io/library/ubuntu:22.04
   ```
2. **Clonando o repositório**

   ```bash
   git clone https://github.com/djdoolky76/o11-v4
   cd o11-v4
   ```

3. **Criando a imagem**

   ```bash
   docker build -t o11-v4 .
   ```

## Rodando o container

Antes de executar o contêiner, decida qual ambiente de execução do servidor você deseja usar:

* **Node.js (Padrão)**
```
sudo docker run -d -p 80:80 -p 443:443 -p 5454:5454 -p 8484:8484 -e IP_ADDRESS=SERVER-IP-HERE -e SERVER_TYPE=nodejs --name o11 o11-v4
```
* **Python**
```
sudo docker run -d -p 80:80 -p 443:443 -p 5454:5454 -p 8484:8484 -e IP_ADDRESS=SERVER-IP-HERE -e SERVER_TYPE=python --name o11 o11-v4
```
**Importante:** Substitua `SERVER-IP-HERE` pelo endereço IP ou domínio do seu servidor.

## Acessando o Painel Web

Assim que o contêiner estiver em execução, abra seu navegador e acesse o:

```
http://SERVER-IP-HERE:8484
```

**Credenciais de Acesso:**
* **Usuário:** `admin`
* **Senha..:** `admin`

## Comandos para uso do container
```bash
# Parar o container
docker stop o11

# Remover o container
docker rm -f o11

# Acesso bash ao container
docker exec -it o11 /bin/bash
- CTRL + D (Sair sem Parar o container) -
```

## Reconhecimento

- Este projeto é um fork de https://github.com/djdoolky76/o11-v4. Todo mérito seja dado inicialmente a ele, eu apenas fiz algumas melhorias para meu cenário.
