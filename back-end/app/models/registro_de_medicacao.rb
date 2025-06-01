class RegistroDeMedicacao < ApplicationRecord
  belongs_to :paciente
  belongs_to :agendamento

  validates :data_hora_tomada, presence: true
  validates :tomou, inclusion: { in: [true, false] }
end
