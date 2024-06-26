class ConsultationsController < ApplicationController
  before_action :set_consultation, only: [:show, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @consultation = Consultation.new
    @consultations = Consultation.all
  end

  def show
    if user_signed_in?
      @appointments = current_user.appointments
      @appointment = Appointment.new
    end
    # if user_signed_in? && @consultation.user != current_user
    #   @appointments =
  end

  def new
    @consultation = Consultation.new
  end

  def create
    @consultation = Consultation.new(consultation_params)
    @consultation.user = current_user

    if @consultation.save
      redirect_to consultation_path(@consultation), notice: "Consultaion was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @consultation.photos.purge
    @consultation.destroy
    redirect_to consultations_path, notice: "Consultaion was successfully deleted."
  end

  private

  def consultation_params
    params.require(:consultation).permit(:price_per_hour,:languages_spoken,:pretty_title,:location_city,:speciality,:years_of_experience,:availability,:duration, photos: [])
  end

  def set_consultation
    @consultation = Consultation.find(params[:id])
  end
end
