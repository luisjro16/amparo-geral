class Api::V1::AgendamentosController < ApplicationController
    def index
        @agendamentos = current_paciente.agendamentos
        render json: @agendamentos
      end

      def show
        @agendamento = current_paciente.agendamentos.find(params[:id])
        render json: @agendamento
      end

      def create
        @agendamento = current_paciente.agendamentos.build(agendamento_params)
        if agendamento.save
          render json: @agendamento, status: :created
        else
          render json: { errors: @agendamento.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        @agendamento = current_paciente.agendamentos.find(params[:id])
        if @agendamento.update(agendamento_params)
          render json: @agendamento
        else
          render json: { errors: @agendamento.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @agendamento = current_paciente.agendamentos.find(params[:id])
        
        @agendamento.destroy
        head :no_content
      end

      private

      def agendamento_params
        params.require(:agendamento).permit(horario, medicamento_id)
      end
end
