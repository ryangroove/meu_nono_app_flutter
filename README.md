# Aplicativo analisador de Texto

# Analisador de Texto – Unidade 2

Aplicativo Flutter desenvolvido para a Unidade 2 da disciplina, com foco em:
- Arquitetura **MVVM**
- **Fluxo completo de autenticação** (Cadastro e Login)
- **Persistência de dados** em banco (Firebase/Firestore)
- **Validações avançadas de formulário**

## Funcionalidades

- Cadastro de usuário com:
  - Nome completo (nome e sobrenome, iniciando com maiúscula)
  - CPF com máscara e validação
  - Data de nascimento com DatePicker
  - E-mail com validação de formato
  - Senha forte (maiúscula, minúscula, número e caractere especial)
  - Confirmação de senha
  - Checklist visual das regras da senha em tempo real
- Login com:
  - Autenticação por e-mail e senha
  - Mensagens de erro em caso de falha
- Tela principal:
  - Sauda o usuário logado: `Bem-vindo, Nome do Usuário!`
  - Campo para digitar texto e botão “Analisar”
- Tela de resultados:
  - Quantidade de palavras, frases e caracteres
  - Tempo estimado de leitura (250 WPM)
  - Top 10 palavras mais frequentes
  - Exibição do texto original

## Arquitetura

O projeto segue o padrão **MVVM**:

- **Models**
  - `Usuario`: representa o usuário cadastrado.
- **Services**
  - `DatabaseService`: comunicação com Firebase/Firestore e hash de senha com `crypto`.
- **ViewModels**
  - `CadastroViewModel`: lógica de estado e validações da tela de cadastro.
  - `LoginViewModel`: lógica de autenticação e estado da tela de login.
- **Views**
  - `tela_cadastro.dart`
  - `tela_login.dart`
  - `tela_principal.dart`
  - `tela_resultados.dart`

## Tecnologias utilizadas

- Flutter
- Provider (gerenciamento de estado)
- Firebase Core e Cloud Firestore
- crypto (hash de senha)
- brasil_fields (máscara/validação de CPF)
