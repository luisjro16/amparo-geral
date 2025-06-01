class CreatePacientes < ActiveRecord::Migration[8.0]
  def change
    create_table :pacientes do |t|
      t.string :nome
      t.string :email
      t.string :senha_digest

      t.timestamps
    end
  end
end
