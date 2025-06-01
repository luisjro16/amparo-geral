class Api::V1::MedicacoesController < ApplicationController
  before_action :set_medicacao, only: %i[show update destroy]

    def index
        @medicacoes = current_paciente.medicacoes
        render json: @medicacoes
      end

      def show
        render json: @medicacao
      end

      def create
        @medicacao = current_paciente.medicacoes.build(medicacao_params)
        if @medicacao.save
          render json: @medicacao, status: :created
        else
          render json: { errors: @medicacao.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @medicacao.update(medicacao_params)
          render json: @medicacao
        else
          render json: { errors: @medicacao.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @medicacao.destroy
        head :no_content
      end

      private

      def medicacao_params
        params.require(:medicacao).permit(:nome, :dose, :composto, :meia_vida, :descricao)
      end

      def set_medicacao
        @medicacao = current_paciente.medicacoes.find(params[:id])
      end
end
