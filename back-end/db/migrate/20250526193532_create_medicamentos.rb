class CreateMedicamentos < ActiveRecord::Migration[8.0]
  def change
    create_table :medicamentos do |t|
      t.string :nome
      t.string :dose
      t.string :composto
      t.string :meia_vida
      t.string :descricao
      t.references :paciente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
