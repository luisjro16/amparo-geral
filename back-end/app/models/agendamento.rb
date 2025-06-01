class Agendamento < ApplicationRecord
  belongs_to :paciente
  belongs_to :medicacao
  has_many :registro_de_tomadas, dependent: :destroy

  validates :horario, presence: true
end
