# 📚 Projeto: Banco de Dados do Ecosy

## 📘 Descrição Geral
Este projeto tem como objetivo desenvolver um **banco de dados relacional completo** para uma **editora de livros**, abordando todas as etapas do processo editorial — desde o cadastro de autores e obras até o controle de estoque, vendas e pedidos.  
O sistema busca garantir a **integração das informações**, **facilidade de consulta** e **eficiência operacional** para a gestão da empresa.

---

## 🏛️ Minimundo – Editora

A **Editora Literarte** (nome fictício) é uma empresa dedicada à publicação, distribuição e venda de livros. Seu funcionamento envolve diferentes setores, colaboradores, autores e clientes.  
O banco de dados proposto visa integrar e automatizar esses processos.

### **Livros**
Cada **livro** é identificado por um **ISBN único** e contém informações como **título**, **autor(es)**, **editora**, **data de publicação**, **gênero**, **número de páginas** e **descrição**.  
Os livros podem pertencer a uma **ou mais áreas de conhecimento**, estar associados a **palavras-chave** e possuir **diversos exemplares físicos** controlados pelo sistema.

### **Autores**
Os **autores** são cadastrados com um **ID único**, contendo **nome**, **biografia**, **nacionalidade**, **data de nascimento** e **obras escritas**.  
Um autor pode escrever **vários livros**, e cada livro pode ter **mais de um autor**, configurando uma relação **n:n**.

### **Departamentos**
Os **departamentos** representam as divisões internas da editora, como *Editorial*, *Marketing*, *Financeiro* e *Vendas*.  
Cada departamento tem um **ID**, **nome**, **descrição das atividades** e é **gerenciado por um funcionário**.  
Um departamento pode ter **vários funcionários**, mas cada funcionário pertence a **um único departamento**.

### **Funcionários**
Os **funcionários** são identificados por seu **CPF**, e armazenam dados como **nome**, **cargo**, **telefone** e **endereço**.  
São responsáveis por registrar pedidos, atender clientes e realizar as atividades administrativas da editora.

### **Exemplares**
Cada **exemplar físico** de um livro possui um **número de série único**, **status** (como *disponível*, *reservado*, *vendido* ou *danificado*) e **localização física** (endereço, bairro, cidade, UF).  
Essa entidade permite o controle de estoque detalhado.

### **Áreas de Conhecimento**
Os livros são categorizados em **áreas de conhecimento**, cada uma com um **código** e uma **descrição**, como “Ciências Humanas”, “Tecnologia”, “Saúde”, entre outras.

### **Palavras-chave**
As **palavras-chave** são cadastradas com um **código** e uma **descrição**.  
Cada livro pode estar associado a várias palavras-chave, facilitando a indexação e as buscas temáticas.

### **Clientes**
Os **clientes** são as pessoas que realizam pedidos. Cada cliente possui um **ID**, **nome**, **endereço**, **telefone** e **e-mail**.  
Podem efetuar vários pedidos ao longo do tempo.

### **Pedidos e Vendas**
Os **pedidos** registram as transações entre clientes e a editora.  
Cada pedido possui um **ID**, **data da transação**, **status**, **forma de pagamento**, e é **registrado por um funcionário** e **efetuado por um cliente**.  
Um pedido pode conter **vários livros**, e cada livro pode aparecer em **diversos pedidos**, criando a entidade associativa **Livros_Pedidos**, que também guarda a **quantidade solicitada**.

---

## 📋 O que foi pedido

De acordo com os requisitos do projeto, foram desenvolvidos:

- Minimundo com descrição detalhada do domínio de negócio.
- Modelagem Entidade-Relacionamento (MER).
- Modelagem Relacional (MR).
- Documento explicativo com imagens dos diagramas.
- Scripts SQL organizados e documentados, incluindo:
- Criação de tabelas e views (DDL).
- Alterações nas tabelas (mínimo 10 ALTERs).
- Exclusão de todas as tabelas, views e dependências.
- Inserção de dados (mínimo 20 registros por tabela).
- Atualizações e exclusões de dados (mínimo 20 DML).
- Relatórios/consultas importantes (mínimo 20 SELECTs com JOINs e Subselects).
- Criação de views para relatórios (mínimo 10).

--

## 🧩 O que colocamos além do pedido
Além das entidades solicitadas inicialmente, foram adicionadas:
- **Cliente**, para permitir o registro completo de vendas e pedidos;  
- **Livros_Pedidos**, entidade associativa para representar a relação *n:n* entre *Livros* e *Pedidos* e armazenar a **quantidade** de exemplares solicitados;  
- Atributos de **localização detalhada** para exemplares;  
- Relacionamento de **gestão entre Departamento e Funcionário**, permitindo identificar quem gerencia cada setor.

---

## 🧮 MER (Modelo Entidade-Relacionamento)
O **MER** ![MER da Editora](images/EDITORA%20MER%20VERS%C3%83O%20DEFINITIVA.jpg) 
representa graficamente todas as entidades, atributos e relacionamentos descritos acima.  

Principais relacionamentos:
- *Autor* escreve *Livro* (n:n)  
- *Livro* pertence a *Área de Conhecimento* (n:1)  
- *Livro* possui *Palavra-Chave* (n:n)  
- *Livro* tem *Exemplar* (1:n)  
- *Pedido e Venda* é registrado por *Funcionário* (n:1)  
- *Pedido e Venda* é efetuado por *Cliente* (n:1)  
- *Pedido e Venda* contém *Livros_Pedidos* (n:n)  
- *Funcionário* pertence a *Departamento* (n:1)  
- *Departamento* é gerenciado por um *Funcionário* (1:1)

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
- **Arthur Filipe** – @gmail.com
- **Filipe Xavier** – @gmail.com   
- **Maria Cecília de Lima e Silva** – cecilmari33@gmail.com  
- **Maria Eduarda Pereira Vilarim** – vilarim051@gmail.com
- **Matheus Alves** – @gmail.com
   
