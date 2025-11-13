# 📚 Projeto: Banco de Dados do Ecosy

## 📘 Descrição Geral
O Ecosy é um sistema desenvolvido para gerenciar e monitorar o processo de distribuição de sementes a beneficiários cadastrados em programas socioambientais. 
O sistema tem como principal objetivo organizar as etapas de aquisição, armazenamento e entrega de lotes de sementes, assegurando rastreabilidade, controle de estoque e transparência nas operações.

A plataforma permite que **usuários autorizados** (como administradores ou operadores) cadastrem **beneficiários**, **endereços** e **entregas**, além de registrarem **observações** e acompanharem o **status** de cada lote. 
Por meio desse controle centralizado, o Ecosy busca otimizar a logística de distribuição e promover um uso mais sustentável dos recursos.

---

## 🏛️ Minimundo – Ecosy

A **Ecosy** é um sistema informatizado de controle de entregas de sementes para beneficiários de programas ambientais.

### **Usuários**
Os **usuários** são os responsáveis por administrar e operar o sistema.
Cada usuário é identificado por um **ID único** e possui informações como **nome**, **sobrenome**, **CPF**, **e-mail**, **senha**, **status** e **nível de acesso** (por exemplo, administrador ou operador).
São eles que realizam o **cadastro de beneficiários**, o **registro de entregas** e o **lançamento de observações** dentro do sistema.

### **Autores**
Os **autores** são cadastrados com um **ID único**, contendo **nome**, **biografia**, **nacionalidade**, **data de nascimento** e **obras escritas**.  
Um autor pode escrever **vários livros**, e cada livro pode ter **mais de um autor**, configurando uma relação **n:n**.

### **Beneficiários**
Os **beneficiários** são as pessoas que recebem as sementes distribuídas pelo projeto.
Cada beneficiário é identificado por um **ID** e contém dados como **nome**, **sobrenome**, **CPF**, **telefone**, **associação** (organização à qual pertence) e **status** (ativo ou inativo).
Os beneficiários são **cadastrados por um usuário** e possuem **endereços associados**, que indicam sua localização para entrega das sementes.

### **Endereços**
Cada beneficiário possui um **endereço** registrado no sistema, contendo **rua**, **cidade**, **estado** e **CEP**.
Essas informações são essenciais para o planejamento das **rotas de entrega** e para a **organização logística** das distribuições realizadas pela Ecosy

### **Lotes**
Os **lotes** representam os conjuntos de sementes disponíveis para distribuição.
Cada lote possui um **ID** e informações como **tipo de semente**, **quantidade em quilogramas**, **data de aquisição**, **origem**, **documento anexo** (comprovante digital) e **status** (por exemplo, disponível, em entrega ou esgotado).
Os lotes são utilizados nas **entregas realizadas aos beneficiários**.

### **Entregas**
As **entregas** registram a distribuição de sementes aos beneficiários.
Cada entrega possui um **ID**, **status da entrega**, **quantidade entregue**, **data da entrega**, **foto do comprovante** e **data de confirmação**.
Uma entrega está sempre associada a **um beneficiário** e **um lote**, sendo **registrada por um usuário**.
Esse controle permite rastrear todas as operações e manter um histórico confiável das ações realizadas.

### **Observações**
As **observações** são anotações registradas por usuários para documentar **ocorrências**, **comentários ou informações complementares** sobre o processo de distribuição.
Cada observação possui um **ID**, **descrição** e **data/hora de registro**, além de estar vinculada a um **usuário** responsável.
Essa funcionalidade contribui para a transparência e monitoramento contínuo do sistema.

## **Relação entre Entidades**
- Um **usuário** pode **cadastrar vários beneficiários**, mas cada beneficiário é cadastrado por **um único usuário**.
- Um **usuário** pode **registrar várias observações**.
- Cada **entrega** está associada a **um beneficiário** e **um lote**.
- Um **beneficiário** possui **um endereço**.
- Um **lote** pode estar vinculado a **diversas entregas**.

---

## 📋 O que foi pedido

De acordo com os requisitos do projeto, foram desenvolvidos:

- Minimundo com descrição detalhada do domínio de negócio.
- Modelagem Conceitual (Diagrama MER).
- Modelagem Lógico (Diagrama MR).
- Documento explicativo com imagens dos diagramas.
- Scripts SQL organizados e documentados, incluindo:
- Criação de tabelas e views (DDL).
- Alterações nas tabelas (mínimo 10 ALTERs).
- Exclusão de todas as tabelas, views e dependências.
- Inserção de dados (mínimo 20 registros por tabela).
- Atualizações e exclusões de dados (mínimo 20 DML).
- Relatórios/consultas importantes (mínimo 20 SELECTs com JOINs e Subselects).
- Criação de views para relatórios (mínimo 10).
- Criação de procedures e funções (mínimo 14 Usando SP/SQL).
- Criação de triggers (mínimo 12 Usando SP/SQL).

---

## 🧮 MER (Modelo Entidade-Relacionamento)
O **MER** ![MER da Editora](Imagens/modeloConceitual-Ecosy.jpg) 
representa graficamente todas as entidades, atributos e relacionamentos descritos acima.  

Principais relacionamentos:


---

## 🗂️ Estrutura dos Scripts / Organização do Repositório

```
📁 /Projeto-Ecosy
├── 📄 README.md                  → Documentação geral do projeto
├── 📁 /images                    → Imagens dos Modelos entidade-relacionamento e relacional
│   ├── EDITORA ME FINAL (png).png
│   └── EDITORA MER VERSÃO DEFINITIVA.jpg
├── 📁 /Scripts
│   ├── 00_create_all.sql          → Criação das tabelas do banco
│   ├── 01_alters.sql              → Alteração de dados na tabela
│   ├── 02_drop_all.sql            → Apagar as tabelas
│   ├── 03_inserts.sql             → Inserção de dados
│   ├── 04_updates_deletes.sql     → Atualização de tabelas e exclusão de dados
│   ├── 05_selects.sql             → Consultas SQL para teste e análise
│   └── 06_views.sql → (Opcional)  → Criação de visões 
└── 📁 /modelos                    → Arquivos de Backup para rodar o modelo nos aplicarivos (BRmodelo e MySQL)
    └── Minimundo_Editora.pdf     
```

---

## 🧠 Conclusão
O projeto resultou em um **modelo de banco de dados relacional robusto**, capaz de abranger todas as operações de uma editora moderna.  
O sistema integra o controle de **autores, livros, exemplares, funcionários, departamentos, pedidos e clientes**, permitindo a geração de relatórios, controle de estoque e análise de vendas.  
O **MER** final garante consistência, escalabilidade e aderência às regras do minimundo descrito.

---

## 👥 Equipe
- **Arthur Filipe Rodrigues da Silva** – arthur.filipe2402@gmail.com
- **Filipe Xavier dos Santos** – xfilipe2006.santos@gmail.com   
- **Maria Cecília de Lima e Silva** – cecilmari33@gmail.com  
- **Maria Eduarda Pereira Vilarim** – vilarim051@gmail.com
- **Matheus Alves de Arruda** – matheusalves2906@gmail.com
   
