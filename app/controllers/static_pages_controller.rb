class StaticPagesController < ApplicationController
  def home
    #
    if current_user
     @transactions = current_user.transactions.where(:status => 0).paginate(page: params[:page], per_page: 4)
     @transactions_by_date = @transactions.group_by(&:deadline)
     @date = params[:date] ? Date.parse(params[:date]) : Date.today
   end
   

   




   
   @locations = Event.all 
 

  
   @json = Gmaps4rails.build_markers(@locations) do |event, marker|
     
      
     if event.dayof + (7) >=Date.today 
       
  
         marker.lat event.latitude
         marker.lng event.longitude
         marker.title event.title
          marker.json({
                id:       event.id, 
                name:     event.title,
                location: event.address,
                website: event.website,
                time: (event.dayof-Date.today+7),
                cat: event.cat,
                date: event.dayof.month.to_s+'/'+event.dayof.day.to_s+'/'+event.dayof.year.to_s
              })
         if event.website ==nil
           event.website=' '
         end



          infowindow_html = "<div class=\"info-window\">" + "<h1><a href=\"/events/" + event.id.to_s + "\">"+event.title+"</a></h1>" + "<p>" + event.dayof.month.to_s+"/"+event.dayof.day.to_s+"/"+event.dayof.year.to_s+"</p>" + "</div>"

          marker.infowindow (
            infowindow_html
          )
             

              #Determine which image to use for the gmaps markers
             if event.cat =='view'
               url='/img/common/marker_red.png'
             elsif event.cat =='tournament'
               url='/img/common/marker_green.png'
             
             elsif event.cat =='con/pax'
               url='/img/common/marker_blue.png'
             else
               url='/img/common/marker_purple.png'
             end
             
           marker.picture({  
              'url' => url,  
              "width"=>  32,
              "height"=> 32
           })
           marker.title event.title
           marker.json({ title: event.title})
        
           end
      end 
    end

  def help
  end
  
  def about
  end
end
