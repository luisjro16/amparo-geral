# Amparo - Aplicativo de Gerenciamento de Medicamentos

## 📖 Visão Geral do Projeto

O **Amparo** é um aplicativo mobile desenvolvido como uma solução intuitiva e confiável para o gerenciamento de medicamentos. O projeto tem como foco principal a usabilidade para garantir a adesão ao tratamento por um público amplo, que inclui idosos e seus cuidadores.

Este projeto foi concebido no âmbito do Departamento de Informática da Faculdade de Ciências Exatas e Naturais da Universidade do Estado do Rio Grande do Norte (UERN).

## 🎯 Contexto e Problema

A gestão correta do uso de medicamentos representa um desafio recorrente, especialmente para idosos, pacientes com doenças crônicas e pessoas que dependem de múltiplos remédios diariamente. A falta de ferramentas eficazes e acessíveis frequentemente leva a esquecimentos, duplicação de doses ou interrupções no tratamento, colocando em risco a saúde dos pacientes.

O Amparo foi proposto como uma solução para promover maior adesão ao tratamento, aumentar a autonomia dos pacientes, diminuir a sobrecarga dos cuidadores e prevenir complicações de saúde.

## 🛠️ Requisitos Técnicos
O aplicativo conta com as seguintes funcionalidades para seu funcionamento:

### Requisitos Funcionais

| Característica | Descrição | Prioridade |
| :--- | :--- | :---: |
| **Cadastro de Usuário** | O aplicativo deve garantir a autenticação do usuário a partir de um cadastro com informações simples coletadas por meio de um formulário. | Alta  |
| **Cadastro Personalizado de Medicamentos** | O sistema deve possibilitar ao usuário cadastrar nome, dosagem, horários e outras informações sobre cada medicamento, a partir de um formulário de cadastro com informações sobre o medicamento. | Alta  |
| **Registro de Doses e Histórico** | O aplicativo deve registrar de forma automatizada e possibilitar registro manual das doses, com histórico acessível para consulta. Dessa forma, se o usuário não tiver tomado a dose no momento do alarme, ela pode ser cadastrada posteriormente, mas será classificada de outra forma. | Alta  |
| **Notificações de Alarme** | O sistema deve prover alarmes visuais e sonoros para lembrar o paciente sobre o horário da medicação. A aplicação deve estar sincronizada com o relógio do  | Alta  |
| **Confirmação de Tomada** | O aplicativo deve exigir a confirmação ativa da dose tomada pelo paciente ou cuidador a partir de um botão na tela de alarme. | Alta  |
| **Funcionalidade Offline** | O sistema deve ter seu funcionamento completo mesmo sem acesso à internet, com sincronização opcional quando disponível. | Alta  |
| **Interface Intuitiva e Acessível** | A aplicação deve conter um design simples e acessível, com foco na usabilidade para idosos e pessoas com baixa alfabetização digital. | Alta  |
| **Relatórios de Adesão** | O aplicativo deve gerar relatórios para acompanhamento da adesão ao tratamento, podendo ser compartilhado | Baixa  |

### Requisitos Não Funcionais

| Tipo | Descrição | Prioridade |
| :--- | :--- | :---: |
| **Usabilidade** | O aplicativo deve ter uma interface simples, com foco em acessibilidade para idosos e usuários com baixa alfabetização digital. | Alta  |
| **Desempenho** | O sistema deve exigir baixo consumo de bateria e recursos do dispositivo garantindo funcionamento adequado mesmo em dispositivos com hardware limitado. | Alta  |
| **Segurança** | O banco de dados da aplicação deve ter um armazenamento local seguro, com os dados sensíveis criptografados. | Alta  |
| **Disponibilidade** | A aplicação deve gerenciar suas operações de forma totalmente offline, sem necessidade de conexão para funcionalidades principais. | Alta  |
| **Interface** | O sistema deve ser compatível com dispositivos Android e iOS, com design responsivo e acessível. | Alta  |

## 🚀 Objetivos

| Objetivo | Descrição |
| :--- | :--- |
| **Melhoria da adesão terapêutica** | Facilitar o gerenciamento do tratamento pelo paciente. |
| **Redução de erros no uso de medicamentos**| Diminuir esquecimentos e a duplicação de doses. |
| **Inclusão digital** | Oferecer uma solução acessível para um público com pouca familiaridade tecnológica. |
| **Fortalecimento institucional** | Alinhar o projeto com as metas do PDTIC, promovendo a saúde digital. |

### Especificações

| Tipo | Especificação |
| :--- | :--- |
| **Sistema Operacional** | Compatível com Android 8.0+ e iOS 13+. |
| **Memória RAM** | O aplicativo deve funcionar com até 2 GB de RAM disponíveis. |
| **Armazenamento** | Aproximadamente 100 MB para instalação. |

## 👥 Partes Interessadas e Equipe

### Cliente

| Nome | E-mail | Responsabilidades |
| :--- | :--- | :--- |
| Alysson Mendes De Oliveira | alyssonoliveira@uern.br  | Responsável por fornecer os requisitos gerais do sistema, validar funcionalidades e aprovar entregas. |

### Equipe de Desenvolvimento

| Nome | Papel | E-mail |
| :--- | :--- | :--- |
| **Larissa Ester Rodrigues Sales Justino** | Product Owner (PO) | larissaestersales@gmail.com  |
| **Luís Jerônimo Rodrigues Oliveira** | Scrum Master | luis20230022178@uern.br  |
| **Eduarda Keila da Silva Moura** | DevOps | eduarda20230033064@alu.uern.br  |
| **Cindy Vitória Alves de Araujo** | Desenvolvedora | araujocindy12@gmail.com  |
| **Maria Eduarda Silva Pinto** | Desenvolvedora | maria20230022427@alu.uern.br  |
| **Ana Beatriz Araújo Silva** | Desenvolvedora | anabaraujo009@gmail.com |

## 📜 Documentação e Padrões

O projeto segue as seguintes diretrizes e normativos:

| Documento/Padrão | Descrição |
| :--- | :--- |
| **PDTIC** | Documento estratégico que orienta iniciativas de transformação digital na saúde. |
| **eMAG** | Modelo de Acessibilidade em Governo Eletrônico. |
| **LGPD** | Lei Geral de Proteção de Dados. |
| **OWASP Mobile Top 10** | Diretrizes para segurança em desenvolvimento de aplicativos móveis. |
