# API Amparo — Documentação

Documentação da API REST do Amparo, desenvolvida com **Django 5.1** e **Django REST Framework**, consumida pelo aplicativo mobile (React Native / Expo).

## Sumário

- [1. Visão Geral](#1-visão-geral)
- [2. Autenticação](#2-autenticação)
  - [2.1 Obter tokens — `POST /api/token/`](#21-obter-tokens--post-apitoken)
  - [2.2 Renovar access token — `POST /api/token/refresh/`](#22-renovar-access-token--post-apitokenrefresh)
- [3. Pacientes — `/api/pacientes/`](#3-pacientes--apipacientes)
  - [3.1 Criar conta — `POST /api/pacientes/`](#31-criar-conta--post-apipacientes)
  - [3.2 Listar — `GET /api/pacientes/`](#32-listar--get-apipacientes)
  - [3.3 Detalhes — `GET /api/pacientes/{id}/`](#33-detalhes--get-apipacientesid)
  - [3.4 Atualizar — `PUT /api/pacientes/{id}/`](#34-atualizar--put-apipacientesid)
  - [3.5 Atualização parcial — `PATCH /api/pacientes/{id}/`](#35-atualização-parcial--patch-apipacientesid)
  - [3.6 Excluir — `DELETE /api/pacientes/{id}/`](#36-excluir--delete-apipacientesid)
- [4. Medicamentos — `/api/medicamentos/`](#4-medicamentos--apimedicamentos)
  - [4.1 Listar — `GET /api/medicamentos/`](#41-listar--get-apimedicamentos)
  - [4.2 Detalhes — `GET /api/medicamentos/{id}/`](#42-detalhes--get-apimedicamentosid)
  - [4.3 Criar — `POST /api/medicamentos/`](#43-criar--post-apimedicamentos)
  - [4.4 Atualizar — `PUT /api/medicamentos/{id}/`](#44-atualizar--put-apimedicamentosid)
  - [4.5 Atualização parcial — `PATCH /api/medicamentos/{id}/`](#45-atualização-parcial--patch-apimedicamentosid)
  - [4.6 Excluir — `DELETE /api/medicamentos/{id}/`](#46-excluir--delete-apimedicamentosid)
- [5. Agendamentos — `/api/agendamentos/`](#5-agendamentos--apiagendamentos)
  - [5.1 Listar — `GET /api/agendamentos/`](#51-listar--get-apiagendamentos)
  - [5.2 Detalhes — `GET /api/agendamentos/{id}/`](#52-detalhes--get-apiagendamentosid)
  - [5.3 Criar — `POST /api/agendamentos/`](#53-criar--post-apiagendamentos)
  - [5.4 Atualizar — `PUT /api/agendamentos/{id}/`](#54-atualizar--put-apiagendamentosid)
  - [5.5 Excluir — `DELETE /api/agendamentos/{id}/`](#55-excluir--delete-apiagendamentosid)
- [6. Registros de Medicação — `/api/registros/`](#6-registros-de-medicação--apiregistros)
  - [6.1 Listar — `GET /api/registros/`](#61-listar--get-apiregistros)
  - [6.2 Detalhes — `GET /api/registros/{id}/`](#62-detalhes--get-apiregistrosid)
  - [6.3 Criar — `POST /api/registros/`](#63-criar--post-apiregistros)
  - [6.4 Atualizar — `PUT /api/registros/{id}/`](#64-atualizar--put-apiregistrosid)
  - [6.5 Atualização parcial — `PATCH /api/registros/{id}/`](#65-atualização-parcial--patch-apiregistrosid)
  - [6.6 Excluir — `DELETE /api/registros/{id}/`](#66-excluir--delete-apiregistrosid)
  - [6.7 Efeito colateral sobre o estoque](#67-efeito-colateral-sobre-o-estoque)
- [7. Referência de modelos](#7-referência-de-modelos)
- [8. Códigos de status](#8-códigos-de-status)
- [9. Fluxos de exemplo](#9-fluxos-de-exemplo)

---

## 1. Visão Geral

- **Base URL (desenvolvimento):** `http://127.0.0.1:8000`
- **Base URL (celular/Expo Go):** usar o IP da máquina na rede local (ex.: `http://192.168.0.10:8000`), o mesmo configurado em `EXPO_PUBLIC_API_URL`.
- **Formato:** apenas JSON (`Content-Type: application/json`).
- **Prefixo da API:** todos os recursos ficam sob `/api/`.

### Autenticação

A API usa **JWT Bearer** (`rest_framework_simplejwt`):

- **Access token:** válido por **1 dia**
- **Refresh token:** válido por **7 dias**

Todo endpoint exige o cabeçalho `Authorization: Bearer <access_token>`, **exceto**:

| Endpoint | Público |
|---|---|
| `POST /api/token/` | Sim |
| `POST /api/token/refresh/` | Sim |
| `POST /api/pacientes/` (criar conta) | Sim |

Todos os recursos são **filtrados pelo paciente autenticado**: cada usuário só enxerga e manipula os dados que pertencem a ele.

### Convenções das respostas

- Listagens retornam **arrays** (sem paginação).
- Erros de validação do DRF seguem o formato `{ "campo": ["mensagem", ...] }` ou `{ "detail": "mensagem" }`.
- Identificadores (`id`) são inteiros gerados automaticamente.

---

## 2. Autenticação

### 2.1 Obter tokens — `POST /api/token/`

**Autenticação:** nenhuma (pública)

**Body:**

| Campo | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| `username` | string | Sim | Nome de usuário da conta |
| `password` | string | Sim | Senha |

**cURL:**

```bash
curl -X POST http://127.0.0.1:8000/api/token/ \
  -H "Content-Type: application/json" \
  -d '{"username": "maria", "password": "1234"}'
```

**Respostas:**

- **200 OK**

```json
{
  "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

- **400 Bad Request** — campo ausente:

```json
{ "password": ["Este campo é obrigatório."] }
```

- **401 Unauthorized** — credenciais inválidas:

```json
{ "detail": "No active account found with the given credentials" }
```

### 2.2 Renovar access token — `POST /api/token/refresh/`

**Autenticação:** nenhuma (pública)

**Body:** `{ "refresh": "<refresh_token>" }`

**cURL:**

```bash
curl -X POST http://127.0.0.1:8000/api/token/refresh/ \
  -H "Content-Type: application/json" \
  -d '{"refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."}'
```

**Respostas:**

- **200 OK** — gera um novo access token:

```json
{ "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." }
```

- **400 Bad Request**

```json
{ "refresh": ["Este campo é obrigatório."] }
```

- **401 Unauthorized** — refresh inválido ou expirado:

```json
{
  "detail": "Token is invalid or expired",
  "code": "token_not_valid"
}
```

---

## 3. Pacientes — `/api/pacientes/`

Recurso que representa as contas dos usuários (modelo `Paciente`).

**Campos retornados nas leituras (`GET`):**

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | int | Identificador |
| `username` | string | Nome de usuário (único) |
| `email` | string | E-mail |
| `first_name` | string | Primeiro nome |
| `last_name` | string | Sobrenome |

### 3.1 Criar conta — `POST /api/pacientes/`

**Autenticação:** nenhuma (pública — único POST público além dos tokens)

**Body:**

| Campo | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| `username` | string | Sim | Nome de usuário (único) |
| `password` | string | Sim | Senha (mínimo 4 caracteres) |

> **Importante:** o app não cadastra e-mail no formulário. O backend gera automaticamente `email = <username>@amparo.app`. A resposta de criação contém **apenas** `username` (o campo `password` é somente escrita e nunca é retornado).

**cURL:**

```bash
curl -X POST http://127.0.0.1:8000/api/pacientes/ \
  -H "Content-Type: application/json" \
  -d '{"username": "maria", "password": "1234"}'
```

**Respostas:**

- **201 Created**

```json
{ "username": "maria" }
```

- **400 Bad Request** — e-mail gerado em conflito (nome de usuário já usado anteriormente):

```json
{ "error": "Um erro inesperado ocorreu. Tente um nome de usuário diferente." }
```

- **400 Bad Request** — nome de usuário duplicado:

```json
{
  "username": [
    "já existe um usuário com este nome de usuário."
  ]
}
```

- **400 Bad Request** — senha muito curta/fraco:

```json
{
  "password": [
    "Esta senha é muito curta. Ela deve conter no mínimo 4 caracteres."
  ]
}
```

### 3.2 Listar — `GET /api/pacientes/`

**Autenticação:** obrigatória

Retorna sempre **apenas o perfil do usuário autenticado** (a consulta é filtrada por `request.user`).

**cURL:**

```bash
curl http://127.0.0.1:8000/api/pacientes/ \
  -H "Authorization: Bearer <access_token>"
```

**Respostas:**

- **200 OK**

```json
[
  {
    "id": 1,
    "username": "maria",
    "email": "maria@amparo.app",
    "first_name": "",
    "last_name": ""
  }
]
```

- **401 Unauthorized**

```json
{ "detail": "Authentication credentials were not provided." }
```

### 3.3 Detalhes — `GET /api/pacientes/{id}/`

**Autenticação:** obrigatória

> Solicitar um `id` de **outro usuário** retorna **404**, pois o queryset é filtrado pelo usuário logado.

**cURL:**

```bash
curl http://127.0.0.1:8000/api/pacientes/1/ \
  -H "Authorization: Bearer <access_token>"
```

**Respostas:**

- **200 OK** — mesmo formato do item de listagem
- **401 Unauthorized**
- **404 Not Found** — id inexistente ou de outro usuário

```json
{ "detail": "Não encontrado." }
```

### 3.4 Atualizar — `PUT /api/pacientes/{id}/`

**Autenticação:** obrigatória

**Body (todos os campos editáveis):**

```json
{
  "username": "maria.silva",
  "email": "maria@example.com",
  "first_name": "Maria",
  "last_name": "Silva"
}
```

**cURL:**

```bash
curl -X PUT http://127.0.0.1:8000/api/pacientes/1/ \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"username": "maria.silva", "email": "maria@example.com", "first_name": "Maria", "last_name": "Silva"}'
```

**Respostas:**

- **200 OK** — perfil atualizado no formato de leitura
- **400 Bad Request** — validação
- **401 Unauthorized** / **404 Not Found**

### 3.5 Atualização parcial — `PATCH /api/pacientes/{id}/`

**Autenticação:** obrigatória

Envia apenas os campos que deseja alterar.

**cURL:**

```bash
curl -X PATCH http://127.0.0.1:8000/api/pacientes/1/ \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"first_name": "Maria"}'
```

**Respostas:** `200 OK` (perfil atualizado), `400`, `401`, `404`.

### 3.6 Excluir — `DELETE /api/pacientes/{id}/`

**Autenticação:** obrigatória

Exclui a conta e, por cascata, medicamentos, agendamentos e registros vinculados.

**cURL:**

```bash
curl -X DELETE http://127.0.0.1:8000/api/pacientes/1/ \
  -H "Authorization: Bearer <access_token>"
```

**Respostas:** `204 No Content`, `401 Unauthorized`, `404 Not Found`.

---

## 4. Medicamentos — `/api/medicamentos/`

Recurso que representa cada medicamento e seus **agendamentos de horários**.

**Campos retornados nas leituras (`GET`):**

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | int | Identificador |
| `nome` | string | Nome do medicamento |
| `dosagem_valor` | decimal | Valor numérico da dosagem (ex.: `600.00`) |
| `dosagem_unidade` | string | Unidade — um de: `mg`, `g`, `ml`, `gotas`, `comprimido(s)`, `cápsula(s)` |
| `observacao` | string | Observações (ex.: "Tomar após as refeições") |
| `estoque_atual` | decimal | Quantidade em estoque |
| `aviso_estoque_minimo` | int | Limite para alerta de estoque baixo |
| `is_active` | boolean | Se o medicamento está ativo |
| `horario_inicio` | string\|null | Primeiro horário do dia (`HH:MM:SS`) — **campo computado** |
| `horario_fim` | string\|null | Último horário do dia — **só preenchido se houver mais de 1 agendamento** |
| `intervalo` | int\|null | Intervalo em horas entre as doses (24 se houver apenas 1 horário) — **campo computado** |
| `duracao_valor` | int\|null | Dias restantes de tratamento (`data_fim` − hoje, mínimo 0) — **campo computado** |

> Os campos `horario_inicio`, `horario_fim`, `intervalo` e `duracao_valor` são **calculados** a partir dos agendamentos vinculados e não são armazenados no banco.

### 4.1 Listar — `GET /api/medicamentos/`

**Autenticação:** obrigatória

Lista apenas os medicamentos do usuário logado, **ordenados por nome**.

**cURL:**

```bash
curl http://127.0.0.1:8000/api/medicamentos/ \
  -H "Authorization: Bearer <access_token>"
```

**Respostas:**

- **200 OK**

```json
[
  {
    "id": 3,
    "nome": "Ibuprofeno",
    "dosagem_valor": "600.00",
    "dosagem_unidade": "mg",
    "observacao": "Tomar após as refeições",
    "estoque_atual": "18.00",
    "aviso_estoque_minimo": 5,
    "is_active": true,
    "horario_inicio": "08:00:00",
    "horario_fim": "16:00:00",
    "intervalo": 8,
    "duracao_valor": 5
  }
]
```

- **401 Unauthorized**

### 4.2 Detalhes — `GET /api/medicamentos/{id}/`

**Autenticação:** obrigatória

**cURL:**

```bash
curl http://127.0.0.1:8000/api/medicamentos/3/ \
  -H "Authorization: Bearer <access_token>"
```

**Respostas:** `200 OK` (mesmo formato do item de listagem), `401`, `404`.

### 4.3 Criar — `POST /api/medicamentos/`

**Autenticação:** obrigatória

Cria o medicamento e **gera automaticamente os agendamentos do dia** baseados no intervalo. A operação é atômica (se algo falhar, nada é gravado).

**Body:**

| Campo | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| `nome` | string | Sim | Nome do medicamento |
| `dosagem_valor` | decimal | Não | Valor da dosagem |
| `dosagem_unidade` | string | Não | `mg` (padrão), `g`, `ml`, `gotas`, `comprimido(s)`, `cápsula(s)` |
| `observacao` | string | Não | Observações |
| `estoque_atual` | decimal | Não | Padrão `0` |
| `aviso_estoque_minimo` | int | Não | Padrão `5` |
| `horario_inicio` | time | **Sim** | Primeira dose do dia (`HH:MM:SS`) |
| `horario_fim` | time | Não | Última dose do dia (`HH:MM:SS`); se `null`, o dia é tratado até 23:59 |
| `intervalo` | int | **Sim** | Intervalo entre doses em horas (1–24) |
| `duracao_valor` | int | Não | Duração em dias; define `data_fim = hoje + duracao_valor` |

**Regras de geração dos agendamentos:**

- Frequência sempre `"Diário"`.
- São criados horários de `horario_inicio` até `horario_fim` (ou fim do dia), somando `intervalo` horas a cada passo.
- Há um teto de `(24 / intervalo) + 1` horários por medicamento (evita loop infinito).
- Se `duracao_valor` for informado, todos os agendamentos recebem `data_fim`.

**cURL:**

```bash
curl -X POST http://127.0.0.1:8000/api/medicamentos/ \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Ibuprofeno",
    "dosagem_valor": "600.00",
    "dosagem_unidade": "mg",
    "observacao": "Tomar após as refeições",
    "estoque_atual": 20,
    "aviso_estoque_minimo": 5,
    "horario_inicio": "08:00:00",
    "horario_fim": "16:00:00",
    "intervalo": 8,
    "duracao_valor": 7
  }'
```

**Respostas:**

- **201 Created** — retorna o medicamento e os agendamentos gerados:

```json
{
  "medicamento": {
    "id": 3,
    "nome": "Ibuprofeno",
    "dosagem_valor": "600.00",
    "dosagem_unidade": "mg",
    "observacao": "Tomar após as refeições",
    "estoque_atual": "20.00",
    "aviso_estoque_minimo": 5,
    "is_active": true,
    "horario_inicio": "08:00:00",
    "horario_fim": "16:00:00",
    "intervalo": 8,
    "duracao_valor": 7
  },
  "agendamentos": [
    {
      "id": 10,
      "horario": "08:00:00",
      "frequencia": "Diário",
      "data_fim": "2026-08-17",
      "paciente": {
        "id": 1,
        "username": "maria",
        "email": "maria@amparo.app",
        "first_name": "",
        "last_name": ""
      },
      "medicamento": {
        "id": 3,
        "nome": "Ibuprofeno",
        "dosagem_valor": "600.00",
        "dosagem_unidade": "mg",
        "observacao": "Tomar após as refeições",
        "estoque_atual": "20.00",
        "aviso_estoque_minimo": 5,
        "is_active": true,
        "horario_inicio": "08:00:00",
        "horario_fim": "16:00:00",
        "intervalo": 8,
        "duracao_valor": 7
      }
    },
    {
      "id": 11,
      "horario": "16:00:00",
      "frequencia": "Diário",
      "data_fim": "2026-08-17",
      "paciente": {
        "id": 1,
        "username": "maria",
        "email": "maria@amparo.app",
        "first_name": "",
        "last_name": ""
      },
      "medicamento": {
        "id": 3,
        "nome": "Ibuprofeno",
        "dosagem_valor": "600.00",
        "dosagem_unidade": "mg",
        "observacao": "Tomar após as refeições",
        "estoque_atual": "20.00",
        "aviso_estoque_minimo": 5,
        "is_active": true,
        "horario_inicio": "08:00:00",
        "horario_fim": "16:00:00",
        "intervalo": 8,
        "duracao_valor": 7
      }
    }
  ]
}
```

- **400 Bad Request** — campo obrigatório ausente ou intervalo fora de 1–24:

```json
{
  "intervalo": [
    "Assegure-se de que este valor esteja entre 1 e 24."
  ],
  "horario_inicio": [
    "Este campo é obrigatório."
  ]
}
```

- **401 Unauthorized**

### 4.4 Atualizar — `PUT /api/medicamentos/{id}/`

**Autenticação:** obrigatória

Mesmo body do `POST`. Atualiza os dados do medicamento e **apaga e recria todos os agendamentos** conforme o novo intervalo/horários.

**cURL:**

```bash
curl -X PUT http://127.0.0.1:8000/api/medicamentos/3/ \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Ibuprofeno",
    "dosagem_valor": "600.00",
    "dosagem_unidade": "mg",
    "observacao": "Tomar após as refeições",
    "estoque_atual": 18,
    "aviso_estoque_minimo": 5,
    "horario_inicio": "08:00:00",
    "horario_fim": "20:00:00",
    "intervalo": 6,
    "duracao_valor": 7
  }'
```

**Respostas:** `200 OK` (mesmo formato do `POST`, com `medicamento` e `agendamentos`), `400`, `401`, `404`.

### 4.5 Atualização parcial — `PATCH /api/medicamentos/{id}/`

**Autenticação:** obrigatória

Atualiza parcialmente os dados do medicamento **sem recriar os agendamentos**. Aceita qualquer campo da leitura (exceto os computados `horario_inicio`, `horario_fim`, `intervalo`, `duracao_valor`, que não são graváveis).

**cURL:**

```bash
curl -X PATCH http://127.0.0.1:8000/api/medicamentos/3/ \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"estoque_atual": 12, "is_active": false}'
```

**Respostas:** `200 OK` (formato de leitura), `400`, `401`, `404`.

### 4.6 Excluir — `DELETE /api/medicamentos/{id}/`

**Autenticação:** obrigatória

Exclui o medicamento e, por cascata, todos os agendamentos e registros de medicação vinculados.

**cURL:**

```bash
curl -X DELETE http://127.0.0.1:8000/api/medicamentos/3/ \
  -H "Authorization: Bearer <access_token>"
```

**Respostas:** `204 No Content`, `401 Unauthorized`, `404 Not Found`.

---

## 5. Agendamentos — `/api/agendamentos/`

Recurso que representa os horários de cada dose de um medicamento.

**Campos retornados (`GET`):**

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | int | Identificador |
| `horario` | time | Horário da dose (`HH:MM:SS`) |
| `frequencia` | string | `Diário` ou `Semanal` |
| `data_fim` | date\|null | Data de fim do tratamento |
| `paciente` | objeto | Perfil do paciente (somente leitura) |
| `medicamento` | objeto | Medicamento vinculado (somente leitura) |

### 5.1 Listar — `GET /api/agendamentos/`

**Autenticação:** obrigatória

Lista os agendamentos do usuário logado, **ordenados pela data de criação (mais recentes primeiro)**.

**cURL:**

```bash
curl http://127.0.0.1:8000/api/agendamentos/ \
  -H "Authorization: Bearer <access_token>"
```

**Respostas:**

- **200 OK**

```json
[
  {
    "id": 11,
    "horario": "16:00:00",
    "frequencia": "Diário",
    "data_fim": "2026-08-17",
    "paciente": {
      "id": 1,
      "username": "maria",
      "email": "maria@amparo.app",
      "first_name": "",
      "last_name": ""
    },
    "medicamento": {
      "id": 3,
      "nome": "Ibuprofeno",
      "dosagem_valor": "600.00",
      "dosagem_unidade": "mg",
      "observacao": "Tomar após as refeições",
      "estoque_atual": "18.00",
      "aviso_estoque_minimo": 5,
      "is_active": true,
      "horario_inicio": "08:00:00",
      "horario_fim": "16:00:00",
      "intervalo": 8,
      "duracao_valor": 5
    }
  }
]
```

- **401 Unauthorized**

### 5.2 Detalhes — `GET /api/agendamentos/{id}/`

**Autenticação:** obrigatória

**cURL:**

```bash
curl http://127.0.0.1:8000/api/agendamentos/11/ \
  -H "Authorization: Bearer <access_token>"
```

**Respostas:** `200 OK` (formato do item de listagem), `401`, `404`.

### 5.3 Criar — `POST /api/agendamentos/`

**Autenticação:** obrigatória

**Body (campos graváveis):**

| Campo | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| `horario` | time | Sim | Horário da dose |
| `frequencia` | string | Sim | `Diário` ou `Semanal` |
| `data_fim` | date | Não | Data de fim do tratamento |

**cURL:**

```bash
curl -X POST http://127.0.0.1:8000/api/agendamentos/ \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"horario": "12:00:00", "frequencia": "Diário", "data_fim": "2026-08-17"}'
```

**Respostas:**

- **201 Created** — formato de leitura (agendamento com `paciente` e `medicamento` aninhados)
- **400 Bad Request** — validação
- **401 Unauthorized**

> **Atenção / limitação atual:** no serializer de escrita, os campos `medicamento` e `paciente` são **somente leitura**. Por isso não é possível vincular um medicamento pelo `POST /api/agendamentos/`, e a persistência tende a falhar por falta de `medicamento`. Na prática, os agendamentos **são criados automaticamente** pelos endpoints `POST`/`PUT` de medicamentos (seção 4.3/4.4). O fluxo do app usa o recurso de agendamentos apenas para **leitura** e para deletar.

### 5.4 Atualizar — `PUT /api/agendamentos/{id}/`

**Autenticação:** obrigatória

Body igual ao do `POST` (apenas os campos graváveis). Não altera o `medicamento`/`paciente` vinculados.

**cURL:**

```bash
curl -X PUT http://127.0.0.1:8000/api/agendamentos/11/ \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"horario": "12:30:00", "frequencia": "Diário", "data_fim": "2026-08-17"}'
```

**Respostas:** `200 OK`, `400`, `401`, `404`.

### 5.5 Excluir — `DELETE /api/agendamentos/{id}/`

**Autenticação:** obrigatória

Exclui o agendamento e, por cascata, os registros de medicação vinculados.

**cURL:**

```bash
curl -X DELETE http://127.0.0.1:8000/api/agendamentos/11/ \
  -H "Authorization: Bearer <access_token>"
```

**Respostas:** `204 No Content`, `401 Unauthorized`, `404 Not Found`.

---

## 6. Registros de Medicação — `/api/registros/`

Recurso que registra se uma dose foi tomada ou não em uma data/hora.

**Campos retornados nas leituras (`GET`):**

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | int | Identificador |
| `data_hora_tomada` | datetime | Quando a dose ocorreu (ISO 8601, UTC) |
| `tomou` | boolean | `true` = tomou, `false` = não tomou |
| `agendamento` | objeto | Agendamento vinculado, com `paciente` e `medicamento` aninhados |

### 6.1 Listar — `GET /api/registros/`

**Autenticação:** obrigatória

Lista os registros do usuário logado, **ordenados pela data/hora da dose (mais recentes primeiro)**.

**cURL:**

```bash
curl http://127.0.0.1:8000/api/registros/ \
  -H "Authorization: Bearer <access_token>"
```

**Respostas:**

- **200 OK**

```json
[
  {
    "id": 22,
    "data_hora_tomada": "2026-08-10T08:00:00Z",
    "tomou": true,
    "agendamento": {
      "id": 10,
      "horario": "08:00:00",
      "frequencia": "Diário",
      "data_fim": "2026-08-17",
      "paciente": {
        "id": 1,
        "username": "maria",
        "email": "maria@amparo.app",
        "first_name": "",
        "last_name": ""
      },
      "medicamento": {
        "id": 3,
        "nome": "Ibuprofeno",
        "dosagem_valor": "600.00",
        "dosagem_unidade": "mg",
        "observacao": "Tomar após as refeições",
        "estoque_atual": "18.00",
        "aviso_estoque_minimo": 5,
        "is_active": true,
        "horario_inicio": "08:00:00",
        "horario_fim": "16:00:00",
        "intervalo": 8,
        "duracao_valor": 5
      }
    }
  }
]
```

- **401 Unauthorized**

### 6.2 Detalhes — `GET /api/registros/{id}/`

**Autenticação:** obrigatória

**cURL:**

```bash
curl http://127.0.0.1:8000/api/registros/22/ \
  -H "Authorization: Bearer <access_token>"
```

**Respostas:** `200 OK` (formato do item de listagem), `401`, `404`.

### 6.3 Criar — `POST /api/registros/`

**Autenticação:** obrigatória

**Body:**

| Campo | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| `agendamento` | int | Sim | `id` do agendamento — **deve pertencer ao usuário logado** |
| `tomou` | boolean | Não | `true`/`false` (padrão `false`) |
| `data_hora_tomada` | datetime | Sim | Momento da dose em ISO 8601 |

**cURL:**

```bash
curl -X POST http://127.0.0.1:8000/api/registros/ \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "agendamento": 10,
    "tomou": true,
    "data_hora_tomada": "2026-08-10T08:00:00Z"
  }'
```

**Respostas:**

- **201 Created** — atenção: nesta criação o `agendamento` é devolvido como **código inteiro** (PK), não como objeto:

```json
{
  "agendamento": 10,
  "tomou": true,
  "data_hora_tomada": "2026-08-10T08:00:00Z"
}
```

- **400 Bad Request** — agendamento de outro usuário é rejeitado:

```json
{
  "agendamento": [
    "Objeto inválido. (Selecione um agendamento válido.)"
  ]
}
```

- **401 Unauthorized**

> **Efeito colateral:** ao criar com `tomou = true`, o estoque do medicamento é debitado automaticamente. Ver [6.7](#67-efeito-colateral-sobre-o-estoque).

### 6.4 Atualizar — `PUT /api/registros/{id}/`

**Autenticação:** obrigatória

**Body:**

```json
{
  "tomou": true,
  "data_hora_tomada": "2026-08-10T08:30:00Z"
}
```

**cURL:**

```bash
curl -X PUT http://127.0.0.1:8000/api/registros/22/ \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"tomou": true, "data_hora_tomada": "2026-08-10T08:30:00Z"}'
```

**Respostas:**

- **200 OK** — retorna o **formato completo de leitura** (com `agendamento` aninhado), conforme [6.1](#61-listar--get-apiregistros)
- **400 Bad Request**, **401 Unauthorized**, **404 Not Found**

### 6.5 Atualização parcial — `PATCH /api/registros/{id}/`

**Autenticação:** obrigatória

Ambos os campos são opcionais — envia só o que mudou.

**cURL:**

```bash
curl -X PATCH http://127.0.0.1:8000/api/registros/22/ \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"tomou": false}'
```

**Respostas:** `200 OK` (formato completo de leitura), `400`, `401`, `404`.

### 6.6 Excluir — `DELETE /api/registros/{id}/`

**Autenticação:** obrigatória

**cURL:**

```bash
curl -X DELETE http://127.0.0.1:8000/api/registros/22/ \
  -H "Authorization: Bearer <access_token>"
```

**Respostas:** `204 No Content`, `401 Unauthorized`, `404 Not Found`.

> Excluir um registro não devolve o estoque (o efeito colateral só reage a criações e alterações de `tomou`).

### 6.7 Efeito colateral sobre o estoque

Ao criar ou atualizar um registro via API, o backend **ajusta automaticamente** o `estoque_atual` do medicamento relacionado (lógica no `save()` do model `RegistroMedicacao`):

| Operação | Efeito no estoque |
|---|---|
| Criar com `tomou = true` | **Diminui** |
| Alterar de `tomou = false` → `true` | **Diminui** |
| Alterar de `tomou = true` → `false` | **Aumenta** (estorno) |
| Alterar `data_hora_tomada` apenas | Nenhum |
| Excluir registro | Nenhum |

**Quantidade movimentada:**

- Se `dosagem_unidade` for `mg` ou `g` → movimenta **1** unidade.
- Caso contrário (`ml`, `gotas`, `comprimido(s)`, `cápsula(s)`) → movimenta o valor de `dosagem_valor` (ex.: "2 comprimido(s)" debita 2; sem dosagem, 1).

**Consequências práticas:**

- `POST /api/registros/` com `tomou = true` **não é idempotente**: cada chamada cria um novo registro e debita novamente.
- O estoque **nunca fica negativo** — é limitado a `0`.
- O valor de `estoque_atual` enviado em `POST/PUT` de medicamento serve como saldo inicial; a partir daí o controle é feito pelos registros.

---

## 7. Referência de modelos

### Paciente (conta de usuário)

| Campo | Tipo | Observações |
|---|---|---|
| `id` | int | PK automática |
| `username` | string | Único, obrigatório |
| `email` | email | Único, obrigatório — gerado automaticamente no cadastro (`<username>@amparo.app`) |
| `first_name` | string | Opcional |
| `last_name` | string | Opcional |
| `password` | string | Somente escrita |

### Medicamento

| Campo | Tipo | Observações |
|---|---|---|
| `id` | int | PK automática |
| `paciente` | FK `Paciente` | `on_delete=CASCADE` |
| `nome` | string (255) | Obrigatório |
| `dosagem_valor` | decimal (10,2) | Opcional |
| `dosagem_unidade` | string (20) | Choices: `mg`, `g`, `ml`, `gotas`, `comprimido(s)`, `cápsula(s)` (padrão `mg`) |
| `observacao` | text | Opcional |
| `estoque_atual` | decimal (10,2) | Padrão `0` |
| `aviso_estoque_minimo` | int | Padrão `5` |
| `is_active` | boolean | Padrão `true` |
| `created_at` | datetime | Automático |
| `updated_at` | datetime | Automático |

Campos **calculados** na serialização: `horario_inicio`, `horario_fim`, `intervalo`, `duracao_valor`.

### Agendamento

| Campo | Tipo | Observações |
|---|---|---|
| `id` | int | PK automática |
| `paciente` | FK `Paciente` | `on_delete=CASCADE` |
| `medicamento` | FK `Medicamento` | `on_delete=CASCADE` |
| `horario` | time | Obrigatório |
| `frequencia` | string (50) | Choices: `Diário`, `Semanal` |
| `data_fim` | date | Opcional |
| `created_at` | datetime | Automático |
| `updated_at` | datetime | Automático |

### RegistroMedicacao

| Campo | Tipo | Observações |
|---|---|---|
| `id` | int | PK automática |
| `paciente` | FK `Paciente` | `on_delete=CASCADE` |
| `agendamento` | FK `Agendamento` | `on_delete=CASCADE` |
| `data_hora_tomada` | datetime | Obrigatório |
| `tomou` | boolean | Padrão `false` |
| `created_at` | datetime | Automático |
| `updated_at` | datetime | Automático |

### Relacionamentos (cascata)

```
Paciente 1 ── * Medicamento 1 ── * Agendamento 1 ── * RegistroMedicacao
```

Excluir um paciente remove seus medicamentos; excluir um medicamento remove seus agendamentos; excluir um agendamento remove seus registros.

---

## 8. Códigos de status

| Código | Significado |
|---|---|
| `200 OK` | Sucesso em leituras, atualizações e criação de tokens |
| `201 Created` | Criado com sucesso |
| `204 No Content` | Excluído com sucesso (ou body vazio) |
| `400 Bad Request` | Erro de validação dos dados enviados |
| `401 Unauthorized` | Token ausente, inválido ou expirado |
| `403 Forbidden` | Sem permissão para a ação |
| `404 Not Found` | Recurso inexistente (ou de outro usuário) |
| `500 Internal Server Error` | Erro interno (ex.: violação de integridade) |

---

## 9. Fluxos de exemplo

### 9.1 Criar conta e fazer login

```bash
# 1) Criar conta
curl -X POST http://127.0.0.1:8000/api/pacientes/ \
  -H "Content-Type: application/json" \
  -d '{"username": "maria", "password": "1234"}'

# 2) Obter tokens
curl -X POST http://127.0.0.1:8000/api/token/ \
  -H "Content-Type: application/json" \
  -d '{"username": "maria", "password": "1234"}'
```

### 9.2 Cadastrar um medicamento com agendamentos

```bash
TOKEN="<access_token>"

curl -X POST http://127.0.0.1:8000/api/medicamentos/ \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Amoxicilina",
    "dosagem_valor": "500.00",
    "dosagem_unidade": "mg",
    "estoque_atual": 21,
    "aviso_estoque_minimo": 7,
    "horario_inicio": "08:00:00",
    "horario_fim": "20:00:00",
    "intervalo": 12,
    "duracao_valor": 10
  }'
```

### 9.3 Registrar uma dose (decrementa o estoque)

```bash
# agendamento id 10 (08:00:00, criado no passo anterior)
curl -X POST http://127.0.0.1:8000/api/registros/ \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "agendamento": 10,
    "tomou": true,
    "data_hora_tomada": "2026-08-10T08:00:00Z"
  }'
```

### 9.4 Consultar o estoque depois da dose

```bash
curl http://127.0.0.1:8000/api/medicamentos/3/ \
  -H "Authorization: Bearer $TOKEN"
# "estoque_atual" terá diminuído em relação ao valor cadastrado
```

### 9.5 Renovar o access token antes do vencimento

```bash
curl -X POST http://127.0.0.1:8000/api/token/refresh/ \
  -H "Content-Type: application/json" \
  -d '{"refresh": "<refresh_token>"}'
```
