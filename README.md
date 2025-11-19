# BalancedMind -Frontend Mobile

Aplicativo móvel para promoção de bem-estar e saúde mental no trabalho, com chat de IA e monitoramento diário. Frontend construído em Flutter.

## Índice
- [Arquitetura](#arquitetura)
- [Tecnologias](#tecnologias)
- [Execução do projeto](#execução-do-projeto)
- [Configuração de ambiente](#configuração-de-ambiente)
- [Autenticação e segurança](#autenticação-e-segurança)
- [Funcionalidades e Telas](#funcionlides-e-telas)
  - [/Autenticação](#Autenticação)
  - [/Mentoria IA](#Mentoria-IA)
  - [/Monitoramento](#Monitoramento)
  - [/Dicas](#Dicas)
- [Estrutura de pastas](#Estrutura-de-pastas)

---

## Arquitetura

- **Frontend:** Flutter (Dart)
- **Camadas principais (/lib):**
  - `screens`: Telas visíveis ao usuário (UI).
  - `widgets`: Componentes reutilizáveis (Cards, Bolhas de Chat).
  - `services`: Lógica de comunicação com a API e gerenciamento de sessão.
  - Gerenciamento de Estado: `setState` (Nativo) e `UserSession` (Singleton para tokens).
  - Integração externa: Consumo da BalancedMind API (Spring Boot) via pacote `http`.

## Tecnologias

- Flutter 3.0+ (recomendado)
- Dart 2.17+
- Pacotes Externos:
  - `http`: Requisições RESTful.
  - `url_launcher`: Abertura de links externos.
- Android SDK (para emulação mobile)

## Execução do projeto

### Requisitos
- Flutter SDK instalado
- VS Code ou Android Studio
- Emulador Android ou Dispositivo Físico configurado

### Rodando localmente
Na raiz do projeto, instale as dependências:

```bash
flutter pub get
```

Conecte um dispositivo/emulador e execute:

```bash
flutter run
```

O aplicativo será compilado e instalado no dispositivo conectado.


## Configuração de ambiente

Alguns pontos importantes de configuração no Android:
- Permissões (`AndroidManifest.xml`)
  - Internet: `<uses-permission android:name="android.permission.INTERNET"/>`
  - Queries (Links): Configuração para `https` (pacote url_launcher).

- API Base URL
  - O endpoint da API está configurado em `src/services/api_service.dart:`
  - `https://balancedmind.lat/api/v1`

## Autenticação e segurança

- Autenticação via integração com API (JWT).
- O fluxo implementado no `ApiService` é:
  - Login: Recebe `idToken` e `refreshToken` e armazena em memória (`UserSession`).
  - Requisições: Injeta automaticamente o header `Authorization: Bearer <idToken>`.
  - Renovação Automática: Ao receber um erro `401 Unauthorized`, o app utiliza o endpoint `/auth/refresh` transparentemente para obter um novo token e retenta a operação sem deslogar o usuário.

## Funcionalidades e Telas

### Autenticação
- **Telas:** `LoginScreen`, `RegistrationScreen`

### Cadastro
Cria um novo usuário na base da API.
- **Dados:** Username, Email, Senha.
- **Validação:** Senhas devem coincidir e ter complexidade mínima.

### Login
Autentica o usuário.
- **Fluxo:** Envia credenciais, recebe Tokens JWT e redireciona para a Home.

### Mentoria IA
- **Tela:** `ChatScreen`

### Chatbot
Interface de conversa com a Inteligência Artificial.
- **Integração:** `POST /ai/chat`
- **Recursos:**
  - Envio de mensagem do usuário.
  - Decodificação UTF-8 da resposta da IA.
  - Feedback visual de "digitando" (loading).

### Monitoramento
**Tela:** `BalanceTrackerScreen`

### Monitor Diário
Registro de métricas de saúde e bem-estar.

- **Inputs:**
  - Tempo de Foco (0-12h) - Slider.
  - Qualidade do Descanso (1-5) - Slider.
  - Estado Emocional - Seletor de Emojis.
- **Integração:** `POST /monitor` (Salvar) e `GET /monitor` (Histórico).

### Dicas
**Tela:** `TipsScreen`

### Conteúdo Rico
Biblioteca de artigos curados sobre saúde mental e produtividade.
- **Recursos:**
  - Listagem de cards informativos.
  - Integração com `url_launcher` para abrir a fonte original no navegador.

## Estrutura de pastas

```bash
lib/
├── main.dart               # Ponto de entrada e Configuração de Tema
├── user_session.dart       # Armazenamento volátil de Tokens
├── screens/                # Telas da aplicação
│   ├── login_screen.dart
│   ├── registration_screen.dart
│   ├── main_screen.dart
│   ├── chat_screen.dart
│   ├── tips_screen.dart
│   └── tracker_screen.dart
├── widgets/                # Componentes visuais reutilizáveis
│   ├── chat_bubble.dart
│   ├── article_card.dart
│   └── tracker_card.dart
└── services/               # Camada de Dados
    └── api_service.dart    # Cliente HTTP com Interceptor de Refresh Token
```
