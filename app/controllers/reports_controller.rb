class ReportsController < ApplicationController
  http_basic_authenticate_with name: 'admin', password: '1234qwer', except: [:new]

  def index
    if Report.count == 0
      flash[:alert] = 'No reports to show.'
      return redirect_to :root
    end
    @reports = Report.all.order('created_at DESC')
    @movies = @reports.map{|r| Movie.find(r.movie_id, false)}.uniq
  end

  def show
    @movie = Movie.find(params[:id], false)
    @reports = Report.where(:movie_id => @movie.id)

    if @reports.nil?
      flash[:alert] = 'No report with id #{params[:id]} found.'
      return redirect_to manage_reports_path
  end

  def new
    if params[:description] == nil || params[:description] == ''
      flash[:alert] = 'Please enter a description for your report'
      return redirect_to movie_path(Movie.find(params[:movie_id]))
    end

    @report = Report.create(movie_id: params[:movie_id].to_i, description: params[:description][0..300], category: params[:type], user_id: params[:user_id])
    flash[:notice] = 'Report sent, thanks for your feedback!'
    redirect_to movie_path(Movie.find(params[:movie_id].to_i))
  end

  def destroy
    Report.find(params[:id]).delete
    flash[:notice] = 'Report deleted'
    redirect_to manage_reports_path
  end

  private
    def report_params
      params.require(:report).permit(
        :description,
        :movie_id
      )
    end
end
