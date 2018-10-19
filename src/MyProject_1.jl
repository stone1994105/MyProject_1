# This is a project for the computational physics course Fall 2018 at the Perimeter Institute
# The goal of this project is to get familiar with Julia language features and practice them

module MyProject_1

using Plots
using DataFrames
using Dates
using StatsBase
##############################################################################################################################################

CITY_DATA = Dict("Chicago" => "chicago.csv", "New York City" => "new_york_city.csv", "Washington" => "washington.csv")

export load_data
function load_data(city::String, skipmissing = true)
	# load data file into a dataframe
	# By default, delete the rows with missing values
	df = readtable(CITY_DATA[city])
	if skipmissing
		dropmissing!(df)
	end
	# convert the Start Time column to datetime
	dateformat = "y-m-d H:M:S"
	df[:Start_Time] = map(x->Date(x,dateformat), df[:Start_Time])
	df[:End_Time] = map(x->Date(x,dateformat), df[:End_Time])
	df
end

export time_stats
function time_stats(df::DataFrame)
	# Displays statistics on the most frequent times of travel
	println("\nCalculating The Most Frequent Times of Travel...\n")
	@time begin
		# display the most common month
		df[:month] = map(x->Dates.month(x), df[:Start_Time])
		popular_month = mode(df[:month])
		println("The most popular month is:$popular_month")
		# display the most common day of week
		df[:day] = map(x->Dates.dayofweek(x), df[:Start_Time])
		popular_day = mode(df[:day])
		println("The most popular day of week is:$popular_day")
	end
end
	
export station_stats
function station_stats(df::DataFrame)
	# Displays statistics on the most popular stations and trip
	println("\nCalculating The Most Popular Stations and Trip...\n")
	@time begin
	    #display most commonly used start station
	    popular_start_station = mode(df[:Start_Station])
	    println("The most popular start station is:$popular_start_station")
	    # display most commonly used end station
	    popular_end_station = mode(df[:End_Station])
	    println("The most popular end station is:$popular_end_station")
	    # display most frequent combination of start station and end station trip
	    trip = "From" .* df[:Start_Station] .* "to" .* df[:End_Station]
	    popular_trip = mode(trip)
	    println("The most popular combination of start and end stations is:$popular_trip")
	end
end	

export trip_duration_stats
function trip_duration_stats(df::DataFrame)
	# Displays statistics on the total and average trip duration
	println("\nCalculating Trip Duration...\n")
	@time begin
	N = nrow(df)
	# display total travel time
	total_travel_time = sum(df[:Trip_Duration]) / 60
	println("The total travel time (in minutes) is:$total_travel_time")
	# display mean travel time
	mean_travel_time = total_travel_time / N
	println("The mean travel time (in minutes) is:$mean_travel_time")
	end
end

export user_stats
function user_stats(df::DataFrame)
	# Displays statistics on bikeshare users
	println("\nCalculating User Stats...\n")  
	@time begin
		# display counts of user types
		user_types = countmap(dropmissing!(df)[:User_Type])
		@show user_types
		# display counts of gender
		if :Gender in names(df)
			gender = countmap(dropmissing!(df)[:Gender])
			@show gender
		else
			println("There is no data for gender")
		end
		# display earliest, most recent, and most common year of birth
		if :Birth_Year in names(df)
			earliest = minimum(df[:Birth_Year])
			most_recent = maximum(df[:Birth_Year])
			popular = mode(df[:Birth_Year])
			println("The earliest year of birth is $earliest \nThe most recent year of birth is $most_recent \n The most common year of birth is $popular")
		else
			println("There is no data for birth year")
		end
	end
end

export show_results
function show_results(df::DataFrame)
	time_stats(df)
	station_stats(df)
	trip_duration_stats(df)
	user_stats(df)
end

# Practice some Plots
export practice_plots
function practice_plots(df::DataFrame)
	plot(2017 .- df[df.Gender .== "Female", :][:Birth_Year],
	df[df.Gender .== "Female", :][:Trip_Duration] ./60,
	seriestype=:scatter,
	color = "red",
  	label = "Female",
  	title = "Trip Duration vs Age",
  	xlabel = "Age",
 	ylabel = "Trip Duration(min)",
  	xlims = (0,120),
  	ylims = (0,1500),
 	legend =:topright)

	plot!(2017 .- df[df.Gender .== "Male", :][:Birth_Year],
	df[df.Gender .== "Male", :][:Trip_Duration] ./60,
	seriestype=:scatter,
	color = "blue",
  	label = "Male",
 	title = "Trip Duration vs Age",
  	xlabel = "Age",
  	ylabel = "Trip Duration(min)",
 	xlims = (0,120),
	ylims = (0,1500),
	legend =:topright)
end
##############################################################################################################################################

end # module


