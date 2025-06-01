class CreateRegistroDeMedicacaos < ActiveRecord::Migration[8.0]
  def change
    create_table :registro_de_medicacaos do |t|
      t.datetime :data_hora_tomada
      t.boolean :tomou
      t.references :paciente, null: false, foreign_key: true
      t.references :agendamento, null: false, foreign_key: true

      t.timestamps
    end
  end
end
