class Paciente < ApplicationRecord
    has_secure_password # usa bcrypt para senha

    has_many :medicacoes, dependent: :destroy
    has_many :agendamentos, dependent: :destroy
    has_many :registro_de_tomadas, dependent: :destroy

    validates :email, presence: true, uniqueness: true
    validates :senha_4_digitos, length: { is: 4 }, allow_nil: true
end
