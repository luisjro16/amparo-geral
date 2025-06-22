## 📊 Diagrama de Classes - Aplicação Amparo

```mermaid
classDiagram
    class AbstractUser {
        <<Django Model>>
        +username: str
        +password: str
        +email: str
        +first_name: str
        +last_name: str
    }

    class Paciente {
        <<User Model>> 
    }

    class Medicamento {
        <<Django Model>>
        +nome: str
        +dosagem_valor: Decimal
        +dosagem_unidade: str
        +observacao: str
        +is_active: bool
        +created_at: datetime
        +updated_at: datetime
        +dosagem_formatada(): str
    }

    class Agendamento {
        <<Django Model>>
        +horario: time
        +frequencia: str
        +data_fim: date
        +created_at: datetime
        +updated_at: datetime
    }

    class RegistroMedicacao {
        <<Django Model>>
        +data_hora_tomada: datetime
        +tomou: bool
        +created_at: datetime
        +updated_at: datetime
    }

    %% Relações
    AbstractUser <|-- Paciente: herda de

    Paciente "1" --> "*" Medicamento : possui >
    Paciente "1" --> "*" Agendamento : possui >
    Paciente "1" --> "*" RegistroMedicacao : possui >

    Medicamento "1" --> "*" Agendamento : agendado em >
    Agendamento "1" --> "*" RegistroMedicacao : registrado em >
