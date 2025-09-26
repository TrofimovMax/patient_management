# frozen_string_literal: true

class AttendingPhysiciansController < ApplicationController
  before_action :set_attending_physician, only: %i[show edit update destroy]

  # GET /attending_physicians
  def index
    @attending_physicians = AttendingPhysician.all
    render json: @attending_physicians
  end

  # GET /attending_physicians/:id
  def show
    render json: @attending_physician
  end

  # GET /attending_physicians/new
  def new
    @attending_physician = AttendingPhysician.new
    render json: @attending_physician
  end

  # GET /attending_physicians/:id/edit
  def edit
    render json: @attending_physician
  end

  # POST /attending_physicians
  def create
    @attending_physician = AttendingPhysician.new(attending_physician_params)
    if @attending_physician.save
      render json: @attending_physician, status: :created
    else
      render json: { errors: @attending_physician.errors.full_messages }, status: :unprocessable_content
    end
  end

  # PATCH/PUT /attending_physicians/:id
  def update
    if @attending_physician.update(attending_physician_params)
      render json: @attending_physician
    else
      render json: { errors: @attending_physician.errors.full_messages }, status: :unprocessable_content
    end
  end

  # DELETE /attending_physicians/:id
  def destroy
    @attending_physician.destroy
    head :no_content
  end

  private

  def set_attending_physician
    @attending_physician = AttendingPhysician.find(params[:id])
  end

  def attending_physician_params
    params.require(:attending_physician).permit(:first_name, :last_name, :middle_name)
  end
end
