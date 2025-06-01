class Api::V1::PacienteController < ApplicationController
    before_action :set_paciente, only: %i[show update destroy]

    def index
        @pacientes = current_paciente
        render json: @pacientes
    end
    
    def show
        render json: @paciente
    end

    def create
        @paciente = current_paciente.build(paciente_params)
        if @paciente.save
          render json: @paciente, status: :created
        else
          render json: { errors: @paciente.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    def update
        if @paciente.update(paciente_params)
            render json: @paciente
        else
            render json: { errors: @paciente.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @paciente.destroy
        head :no_content
    end
    
    private
    
    def paciente_params
        params.require(:paciente).permit(:nome, :email, :senha_digest)
    end

    def set_paciente
        @paciente = current_paciente.find(params[:id])
    end
end
