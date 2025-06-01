class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_paciente

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    decoded = JsonWebToken.decode(header)
    if decoded
      @current_paciente = Paciente.find_by(id: decoded[:paciente_id])
    end
    render json: { error: 'Acesso negado' }, status: :unauthorized unless @current_paciente
  end
end
