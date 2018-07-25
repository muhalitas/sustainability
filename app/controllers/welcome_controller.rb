class WelcomeController < ApplicationController

  require 'smarter_csv'
  require 'matrix'

    def index
    end

	def gcat
	end

  def results
    @get = SmarterCSV.process('f.csv',{:col_sep => ";", :row_sep => "\n"})

    #Start process retrieving of WebData
	  @model = params[:model]
    @country_result = (params[:country_result]).to_i
    @country = params[:country]
    @sector = params[:sector]
    @quantity = (params[:quantity]).to_i

    #Finish process retrieving of WebData

  #Start process retrieving of E
  @m1=[]
  @m2=[]

  @E = SmarterCSV.process("E#{@model}.csv", {:col_sep => ";", :row_sep => "\n"})


  for i in @E
    i.values.each do |g|
    @m1 << g
    end
  end

  @E = nil

  (0..1434).each do |e|
     @m2[e]= @m1.slice!(0..1434)
    end
    @m2 = Matrix.rows(@m2)
  #Finish process retrieving of E

  change(@country,@sector,@quantity)

  @m5 = @m2*@m3
  @sum= 0

  @b=[]
  @get.each do |l|
      @b << l.values
    end

  @m5.each { |q|  @sum+=q }
  i=0
  @b.each do |t|
    t[2] = @m5[i,0]
    i+=1
  end
  @b=@b.sort_by{|k|k[2]}  #Co2 buyuklugune gore sirala

  @first10 = (@b[-1][2] + @b[-2][2] + @b[-3][2] + @b[-4][2] + @b[-5][2] + @b[-6][2] + @b[-7][2] + @b[-8][2] +@b[-9][2]+ @b[-10][2])

   @first25 = (@b[-1][2] + @b[-2][2] + @b[-3][2] + @b[-4][2] + @b[-5][2] + @b[-6][2] + @b[-7][2] + @b[-8][2] +@b[-9][2]+ @b[-10][2] +

    @b[-11][2] + @b[-12][2] + @b[-13][2] + @b[-14][2] + @b[-15][2] + @b[-16][2] + @b[-17][2] + @b[-18][2] +@b[-19][2]+ @b[-20][2] + @b[-21][2] + @b[-22][2] + @b[-23][2] +@b[-24][2]+ @b[-25][2] )


  @first50 = (@b[-1][2] + @b[-2][2] + @b[-3][2] + @b[-4][2] + @b[-5][2] + @b[-6][2] + @b[-7][2] + @b[-8][2] +@b[-9][2]+ @b[-10][2] +

    @b[-11][2] + @b[-12][2] + @b[-13][2] + @b[-14][2] + @b[-15][2] + @b[-16][2] + @b[-17][2] + @b[-18][2] +@b[-19][2]+ @b[-20][2] + @b[-21][2] + @b[-22][2] + @b[-23][2] +@b[-24][2]+ @b[-25][2] +

    @b[-26][2] + @b[-27][2] + @b[-28][2] + @b[-29][2] + @b[-30][2] + @b[-31][2] + @b[-32][2] + @b[-33][2] +@b[-34][2]+ @b[-35][2] + @b[-36][2] + @b[-37][2] + @b[-38][2] +@b[-39][2]+ @b[-40][2] +

    @b[-41][2] + @b[-42][2] + @b[-43][2] + @b[-44][2] + @b[-45][2] + @b[-46][2] + @b[-47][2] + @b[-48][2] +@b[-49][2]+ @b[-50][2])

@other10 = @sum - @first10

@other25 = @sum - @first25

@other50 = @sum - @first50




  @scope1=0 #The country and the sector's self effect.

  @scope2=0 #Effects of other sectors existing in that country except chosen sector.

  @scope3=0 #Effects of other sectors except those in that country.

  @scope4=0 #Inland, water, air transport

  @scope5=0 #Trade sectors

  @scope6=0 #Other sectors

  #scope 7,8,9 are for real scope analysis

  @scope7=@scope8=@scope9=0

  #scope 7,8,9 are for real scope analysis



  @b.each do |q|
    if q[0]==@country && q[1]==@sector
    @scope1 += q[2]    
    elsif q[0]==@country && q[1]!=@sector
    @scope2 += q[2] 
    else
    @scope3 += q[2]
    end
       if q[0]==@country && q[1]=="Water Transport"
        @scope4 += q[2] 
        elsif q[0]==@country && q[1]=="Inland Transport"
        @scope4 += q[2] 
        elsif q[0]==@country && q[1]=="Air Transport"
        @scope4 += q[2] 
        elsif q[0]==@country && q[1]=="Sale, Maintenance and Repair of Motor Vehicles and Motorcycles; Retail Sale of Fuel"
        @scope5 += q[2] 
        elsif q[0]==@country && q[1]=="Wholesale Trade and Commission Trade, Except of Motor Vehicles and Motorcycles"
        @scope5 += q[2] 
        elsif q[0]==@country && q[1]=="Retail Trade, Except of Motor Vehicles and Motorcycles; Repair of Household Goods"
        @scope5 += q[2] 
        elsif q[0]==@country && q[1]=="Electricity, Gas and Water Supply"
        @scope8 += q[2] 
        end
    
   end

   @scope6 = @scope2 - @scope4 -@scope5

  @scope7 = @scope1
  @scope9 = @sum - @scope7 - @scope8

# Sonuclari ulke bazinda toplama ve results

@u=[]

@Australia_sum = @Austria_sum = @Belgium_sum = @Bulgaria_sum = @Brazil_sum = @Canada_sum = @China_sum = @Cyprus_sum =@CzechRepublic_sum = @Deutschland_sum = @Denmark_sum = @Spain_sum = @Estonia_sum =0
@Finland_sum = @France_sum = @Greece_sum = @Hungary_sum = @Indonesia_sum = @India_sum = @Ireland_sum = @Italy_sum = @Japan_sum = @SouthKorea_sum = @Lithuania_sum  = @Luxembourg_sum = @Latvia_sum = @Mexico_sum = @Malta_sum = @Netherlands_sum = @Poland_sum=0
@Portugal_sum = @Romania_sum = @Russia_sum = @Slovakia_sum = @Slovenia_sum = @Sweden_sum = @Turkey_sum = @Taiwan_sum = @UnitedKingdom_sum = @UnitedStates_sum = @RestofWorld_sum = 0

  @b.each do |t|
    if t[0]== "Australia"
      @Australia_sum += t[2]
    elsif t[0]== "Austria"
      @Austria_sum += t[2]
    elsif t[0]== "Belgium"
      @Belgium_sum += t[2]
    elsif t[0]== "Bulgaria"
      @Bulgaria_sum += t[2]
    elsif t[0]== "Brazil"
      @Brazil_sum += t[2]
    elsif t[0]== "Canada"
      @Canada_sum += t[2]
    elsif t[0]== "China"
      @China_sum += t[2]
    elsif t[0]== "Cyprus"
      @Cyprus_sum += t[2]
    elsif t[0]== "Czech Republic"
      @CzechRepublic_sum += t[2]
    elsif t[0]== "Deutschland"
      @Deutschland_sum += t[2]
    elsif t[0]== "Denmark"
      @Denmark_sum += t[2]
    elsif t[0]== "Spain"
      @Spain_sum += t[2]
    elsif t[0]== "Estonia"
      @Estonia_sum += t[2]
    elsif t[0]== "Finland"
      @Finland_sum += t[2]
    elsif t[0]== "France"
      @France_sum += t[2]
    elsif t[0]=="Greece"
      @Greece_sum += t[2]
    elsif t[0]== "Hungary"
      @Hungary_sum += t[2]
    elsif t[0]== "Indonesia"
      @Indonesia_sum += t[2]
    elsif t[0]== "India"
      @India_sum += t[2]
    elsif t[0]== "Ireland"
      @Ireland_sum += t[2]
    elsif t[0]== "Italy"
      @Italy_sum += t[2]
    elsif t[0]== "Japan"
      @Japan_sum += t[2]
    elsif t[0]== "South Korea"
      @SouthKorea_sum += t[2]
    elsif t[0]== "Lithuania"
      @Lithuania_sum += t[2]
    elsif t[0]== "Luxembourg"
      @Luxembourg_sum += t[2]
    elsif t[0]== "Latvia"
      @Latvia_sum += t[2]
    elsif t[0]== "Mexico"
      @Mexico_sum += t[2]
    elsif t[0]== "Malta"
      @Malta_sum += t[2]
    elsif t[0]== "Netherlands"
      @Netherlands_sum += t[2]
    elsif t[0]== "Poland"
      @Poland_sum += t[2]
    elsif t[0]== "Portugal"
      @Portugal_sum += t[2]
    elsif t[0]== "Romania"
      @Romania_sum += t[2]
    elsif t[0]== "Russia"
      @Russia_sum += t[2]
    elsif t[0]== "Slovakia"
      @Slovakia_sum += t[2]
    elsif t[0]== "Slovenia"
      @Slovenia_sum += t[2]
    elsif t[0]== "Sweden"
      @Sweden_sum += t[2]
    elsif t[0]== "Turkey"
      @Turkey_sum += t[2]
    elsif t[0]== "United Kingdom"
      @UnitedKingdom_sum += t[2]
    elsif t[0]== "United States"
      @UnitedStates_sum += t[2]
    elsif t[0]== "Rest of World"
      @RestofWorld_sum += t[2]
    end
  end

  @T= [ ["Australia", @Australia_sum] ,["Austria", @Austria_sum] , ["Belgium", @Belgium_sum] , ["Bulgaria", @Bulgaria_sum], ["Brazil", @Brazil_sum], ["Canada", @Canada_sum], ["China",  @China_sum], ["Cyprus", @Cyprus_sum] , ["Czech Republic", @CzechRepublic_sum] ,
   ["Deutschland",@Deutschland_sum], ["Denmark", @Denmark_sum] , ["Spain", @Spain_sum], ["Estonia", @Estonia_sum], ["Finland", @Finland_sum] , ["France", @France_sum], ["Greece", @Greece_sum] ,["Hungary", @Hungary_sum], ["Indonesia", @Indonesia_sum], ["India", @India_sum],
   ["Ireland", @Ireland_sum], ["Italy", @Italy_sum], ["Japan",  @Japan_sum], ["South Korea" , @SouthKorea_sum] , ["Lithuania", @Lithuania_sum] , ["Luxembourg", @Luxembourg_sum] , ["Latvia", @Latvia_sum] , ["Mexico", @Mexico_sum] , ["Malta", @Malta_sum] ,["Netherlands", @Netherlands_sum], 
   ["Poland", @Poland_sum], ["Portugal", @Portugal_sum],["Romania", @Romania_sum], ["Russia",  @Russia_sum], ["Slovakia", @Slovakia_sum] ,["Slovenia", @Slovenia_sum] ,["Sweden", @Sweden_sum] ,["Turkey", @Turkey_sum] , ["Taiwan", @Taiwan_sum],
   ["United Kingdom", @UnitedKingdom_sum], ["United States", @UnitedStates_sum] , ["Rest of World", @RestofWorld_sum ]  ]

     @T=@T.sort_by{ |k,n| n} #Co2 buyuklugune gore sirala

end



  def change(country,sector,quantity)
    for i in @get
      if i[:country] == country && i[:sector] == sector
        i[:f] = quantity.to_i
      end
    end
    @m3=[]

    @get.each do |l|
        @m3 << l[:f] #For Matrix multiplication, just numbers.
    end
    
    @m3 = Matrix.column_vector(@m3)

 

  end

end
