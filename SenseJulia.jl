using SenseHat, Colors, Dates, DataFrames, UnicodePlots
########################
const LED = led_matrix()

function julia_logo()
	LED[:] = SenseHat.JULIA_LOGO
	sleep(3)
	led_clear()
end
########################
function usgs_logo()
	 USGS_LOGO = begin
		W = RGB565(.4,.4,.4)
		G = RGB565(.1,.296, .09)
	
	permutedims([G G G G G G W G;
        	 G W W G G W G W;
                 W G G W W G W G;
                 G W W G G W G W;
                 W G G W W G W G;
                 G W W G G W G G;
                 W G G W W G G G;
                 G G G G G G G G], (2,1)) # transpose to correct orientation
	end

	LED[:] = USGS_LOGO
	sleep(3)
	led_clear()
end
##############################
df = DataFrame(DateTime = DateTime[], 
			   Temperature = Float64[],
			   Humidity = Float64[],
			   Pressure = Float64[])			   
			   
function get_data()

	d = Dates.now()
	t = round((temperature() * 9/5) + 32, digits=2) 
	h = round(humidity(), digits=2)
	p = round(pressure()*0.750062, digits=2)
	
	println("Temp: $t C", "   ", "Humidity: $h %", "   ", "Pressure: $p mm/hg")
	push!(df::DataFrame, [d t p h])
	#sleep(1)
end

function print_data()
	
	t = round((temperature() * 9/5) + 32, digits=2)
	show_message("Temp: $t", 0.1)
	
	h = round(humidity(), digits=2)
	show_message("Humid: $h", 0.1)

	p = round(pressure(), digits=2)
	show_message("Pres: $p",0.1)
end	

i = 0
while true
	#julia_logo()
	#usgs_logo()
	#print_data()
	get_data()
	
	if i % 10 === 0
		display(lineplot(df[:DateTime],df[:Temperature], color=:red))
		println("")
	end 
	
	sleep(1)
	
	if i >= 100000
		break
	end
	global i += 1 
end

