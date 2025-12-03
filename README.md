

# Aplicativo Analisador de Texto – Unidade 2  

Projeto desenvolvido em **Flutter** para a Unidade 2 da disciplina, com foco em:  
- Padrão arquitetural **MVVM**  
- **Autenticação completa** (Cadastro e Login)  
- **Persistência de dados** com Firebase/Firestore  
- **Validações avançadas de formulários**  



## Funcionalidades  

### Cadastro de Usuário  
- Nome completo (nome e sobrenome iniciando com maiúscula)  
- CPF com máscara e validação  
- Data de nascimento via **DatePicker**  
- E-mail com verificação de formato  
- Senha forte (maiúscula, minúscula, número e caractere especial)  
- Confirmação de senha  
- Checklist visual das regras da senha em tempo real  

### Login  
- Autenticação por e-mail e senha  
- Exibição de mensagens de erro em caso de falha  

### Tela Principal  
- Saudação personalizada: `Bem-vindo, Nome do Usuário!`  
- Campo de entrada de texto e botão **“Analisar”**  

### Tela de Resultados  
- Contagem de palavras, frases e caracteres  
- Tempo estimado de leitura (250 WPM)  
- Top 10 palavras mais frequentes  
- Exibição do texto original  



## Arquitetura MVVM  

- **Models**  
  - `Usuario`: representa os dados do usuário cadastrado  

- **Services**  
  - `DatabaseService`: responsável pela comunicação com Firebase/Firestore e hash de senha usando `crypto`  

- **ViewModels**  
  - `CadastroViewModel`: gerencia estado e validações da tela de cadastro  
  - `LoginViewModel`: gerencia autenticação e estado da tela de login  

- **Views**  
  - `tela_cadastro.dart`  
  - `tela_login.dart`  
  - `tela_principal.dart`  
  - `tela_resultados.dart`  



## Tecnologias Utilizadas  

- Flutter  
- Provider (gerenciamento de estado)  
- Firebase Core e Cloud Firestore  
- crypto (hash de senha)  
- brasil_fields (máscara e validação de CPF)  

