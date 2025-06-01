class Medicamento < ApplicationRecord
  belongs_to :paciente
  has_many :agendamentos, dependent: :destroy

  validates :nome, :dose, presence: true
end
