class Api::V1::RegistroDeMedicacaoController < ApplicationController
    before_action :set_registro, only: %i[show update destroy]
    
    def index
        @registros = current_registro.registro
        render json: @registros
    end
    
    def show
        render json: @registro
    end

    def create
        @registro = current_registro.registros.build(registro_params)
        if @registro.save
          render json: @registro, status: :created
        else
          render json: { errors: @registro.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    def update
        if @registro.update(registro_params)
            render json: @registro
        else
            render json: { errors: @registro.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @registro.destroy
        head :no_content
    end
    
    private
    
    def registro_params
        params.require(:registro).permit(:nome, :email, :senha_digest)
    end

    def set_registro
        @registro = current_registro.registros.find(params[:id])
    end
end
