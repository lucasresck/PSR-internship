using Plots, StatPlots, DataFrames

function dados_e_plot(G, schedule_matrix, d; title = "", alpha = 0.4, CVaR = zeros(12), legend = false, inverse = false)
    schedule_matrix = Int.(round.(schedule_matrix .- 0.1))
    if inverse
        for i in eachindex(schedule_matrix)
            schedule_matrix[i] = Int(~Bool(schedule_matrix[i]))
        end            
    else        
    end
    if length(size(G)) == 1
        nplants = length(G)
    else
        nplants = size(G)[1]
    end
    if length(size(d)) == 1
        nmonths = length(d)
    else
        nmonths = size(d)[1]
        Ns = size(d)[2]
    end
    schedule = DataFrame(months = collect(1:nmonths), plants_off = [[] for i in 1:nmonths],
        capacity_available = zeros(nmonths))
    for plant in 1:nplants
        for month in 1:nmonths
            if Bool(schedule_matrix[plant, month])
                push!(schedule.plants_off[month], plant)
            else
                if length(size(G)) == 1
                    schedule.capacity_available[month] += G[plant] 
                else
                    schedule.capacity_available[month] += G[plant, month]
                end
            end
        end
    end
    plot1 = heatmap(schedule_matrix, colorbar = false, xlabel = "Meses", ylabel = "Usinas", xaxis = collect(1:nmonths),
        yaxis = collect(1:nplants), color = :PuRd, aspect_ratio = 1, title = "Heatmap das manutenções")
    #plot1 = bar(collect(1:nmonths), [size(plants_off) for plants_off in schedule.plants_off], xlabel = "Months", ylabel = "Number of plants off", aspect_ratio = 1, xaxis = collect(1:nmonths), yaxis = collect(1:nplants), color = :redsblues)
    if length(size(d)) == 1
        return schedule, plot1, groupedbar([schedule.capacity_available d], title = title, label = ["Capacidade", "Demanda"],
            legend = legend, xaxis = collect(1:nmonths), xlabel = "Meses", ylabel = "Energia", ylims = (0, 350))
    else
        if sum(CVaR) == 0
            plot2 = groupedbar([schedule.capacity_available [maximum(d[month, :]) for month in 1:nmonths] [sum(d[month, :]) / Ns for month in 1:nmonths]],
                title = title, label = ["Capacidade", "Maior demanda", "Valor esp. da demanda"],
                legend = legend, xaxis = collect(1:nmonths), xlabel = "Mês", ylabel = "Energia", ylims = (0, 370))
        else
            plot2 = groupedbar([schedule.capacity_available [maximum(d[month, :]) for month in 1:nmonths] CVaR],
                title = title, label = ["Capacidade", "Maior demanda", "CVaR"],
                legend = legend, xaxis = collect(1:nmonths), xlabel = "Mês", ylabel = "Energia", ylims = (0, 370))
        end
        return schedule, plot1, plot2
    end
end;