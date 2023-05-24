class Api::V1::TasksController < ApplicationController

  def index
    # この辺りはかなり簡略化しています。
# 本来であれば seeds.rb を作成した方が良いです...
    if Task.count.zero?
      ['1st task', '2nd task', '3rd task'].each do |title|
        Task.create!(title: title)
      end
    end
# この辺りも本来であればきちんとシリアライズした方が良いです...
    render json: { tasks: Task.all.to_json }
  end

  
end
