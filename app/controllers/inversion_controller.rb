require 'net/http'
require 'uri'
require 'date'

class InversionController < ApplicationController
  def index
  end

  def result
    composition = {
      "risky_norris" => params[:simulacion][:risky_norris].to_f/100, 
      "moderate_pitt" => params[:simulacion][:moderate_pitt].to_f/100, 
      "conservative_clooney" => params[:simulacion][:conservative_clooney].to_f/100
    }
    initial_values_urls = {
      "risky_norris" => "https://fintual.cl/api/real_assets/186/days", 
      "moderate_pitt" => "https://fintual.cl/api/real_assets/187/days", 
      "conservative_clooney" => "https://fintual.cl/api/real_assets/188/days"
    }
    last_day_urls = {
      "risky_norris" => "https://fintual.cl/api/real_assets/186", 
      "moderate_pitt" => "https://fintual.cl/api/real_assets/187", 
      "conservative_clooney" => "https://fintual.cl/api/real_assets/188"
    }

    amount_to_invest = params[:simulacion][:monto_inicial].to_i
    start_date = params[:simulacion][:fecha_inicio]
    
    puts start_date

    initial_values = {}
    final_values = {}
    
    initial_values_urls.each do |name, url|
      if composition[name] > 0
        uri = URI(url)
        uri.query = URI.encode_www_form({:date => start_date})
        res = Net::HTTP.get_response(uri)  
        initial_values.store(name, JSON.parse(res.body)['data'][0]['attributes']['price']) if res.is_a?(Net::HTTPSuccess)
      else
        initial_values.store(name, 0)
      end
    end

    puts initial_values

    last_day_urls.each do |name, url|
      if composition[name] > 0
        date_uri = URI(url)
        date_res = Net::HTTP.get_response(date_uri)  
        final_values.store(name, JSON.parse(date_res.body)['data']['attributes']['last_day']['net_asset_value'] ) if date_res.is_a?(Net::HTTPSuccess)
      else
        final_values.store(name, 0)
      end
    end

    puts final_values

    retorno_inversion = 0
    composition.each do |name, percentage|
      if initial_values[name] > 0 && final_values[name] > 0
        retorno_inversion = retorno_inversion + ((percentage*amount_to_invest)/initial_values[name]) * final_values[name] 
      end
    end
  
    @resultado = retorno_inversion
    @monto_inicial = amount_to_invest
    @fecha_inicial = Date.parse(start_date).strftime("%d/%m/%Y")

    render 'result'
  end
end
