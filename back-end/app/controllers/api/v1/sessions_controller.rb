class Api::V1::SessionsController < ApplicationController
    def create
        paciente = Paciente.find_by(email: params[:email])
        if paciente&.authenticate(params[:senha_4_digitos])
          token = JsonWebToken.encode(paciente_id: paciente.id)
          render json: { token: token }, status: :ok
        else
          render json: { error: 'Credenciais inválidas' }, status: :unauthorized
        end
end
