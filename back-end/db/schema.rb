# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_26_193702) do
  create_table "agendamentos", force: :cascade do |t|
    t.datetime "horario"
    t.integer "paciente_id", null: false
    t.integer "medicamento_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medicamento_id"], name: "index_agendamentos_on_medicamento_id"
    t.index ["paciente_id"], name: "index_agendamentos_on_paciente_id"
  end

  create_table "medicamentos", force: :cascade do |t|
    t.string "nome"
    t.string "dose"
    t.string "composto"
    t.string "meia_vida"
    t.string "descricao"
    t.integer "paciente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paciente_id"], name: "index_medicamentos_on_paciente_id"
  end

  create_table "pacientes", force: :cascade do |t|
    t.string "nome"
    t.string "email"
    t.string "senha_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registro_de_medicacaos", force: :cascade do |t|
    t.datetime "data_hora_tomada"
    t.boolean "tomou"
    t.integer "paciente_id", null: false
    t.integer "agendamento_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agendamento_id"], name: "index_registro_de_medicacaos_on_agendamento_id"
    t.index ["paciente_id"], name: "index_registro_de_medicacaos_on_paciente_id"
  end

  add_foreign_key "agendamentos", "medicamentos"
  add_foreign_key "agendamentos", "pacientes"
  add_foreign_key "medicamentos", "pacientes"
  add_foreign_key "registro_de_medicacaos", "agendamentos"
  add_foreign_key "registro_de_medicacaos", "pacientes"
end
