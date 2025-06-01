class CreateAgendamentos < ActiveRecord::Migration[8.0]
  def change
    create_table :agendamentos do |t|
      t.datetime :horario
      t.references :paciente, null: false, foreign_key: true
      t.references :medicamento, null: false, foreign_key: true

      t.timestamps
    end
  end
end
