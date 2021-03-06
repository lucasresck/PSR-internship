using Plots, StatPlots, DataFrames

function comparison(d, G, dados1, schedule_matrix1, dados2, schedule_matrix2; xlabel1 = "dados1", xlabel2 = "dados2",
        title = "Comparação da capacidade disponível", legend1 = false, expected_value_of_demand = true, y_max1 = 350, heatmap2 = true)
    nplants = length(G)
    nmonths = size(dados1, 1)
    if length(size(d)) == 1
        Ns = 1
    else
        Ns = size(d)[2]
    end
    if expected_value_of_demand
        plot1 = groupedbar([dados1.capacity_available dados2.capacity_available [maximum(d[month, :]) for month in 1:nmonths] [sum(d[month, :]) / Ns for month in 1:nmonths]],
        label = [xlabel1; xlabel2; ["Maior demanda"]; ["Valor esp. da demanda"]],
        xlabel = "Mês", ylabel = "Capacidade", xaxis = collect(1:nmonths), title = title, legend = legend1, ylims = (0, y_max1))
    else
        plot1 = groupedbar([dados1.capacity_available dados2.capacity_available [maximum(d[month, :]) for month in 1:nmonths]],
        label = [xlabel1; xlabel2; ["Maior demanda"]],
        xlabel = "Mês", ylabel = "Capacidade", xaxis = collect(1:nmonths), title = title, legend = legend1, ylims = (0, y_max1))
    end
    plot2 = bar(collect(1:nmonths), [size(dados1.plants_off[month])[1] for month in 1:nmonths], xaxis = collect(1:nmonths),
        ylabel = "Nº de usinas desligadas", xlabel = xlabel1, legend = false)
    plot3 = bar(collect(1:nmonths), [size(dados2.plants_off[month])[1] for month in 1:nmonths], xaxis = collect(1:nmonths),
        xlabel = xlabel2, legend = false)
    if heatmap2 == true
        plot4 = heatmap(schedule_matrix1, colorbar = false, xlabel = "Meses", ylabel = "Usinas", xaxis = collect(1:nmonths),
            yaxis = collect(1:nplants), color = :PuRd, aspect_ratio = 1)
        plot5 = heatmap(schedule_matrix2, colorbar = false, xlabel = "Meses", xaxis = collect(1:nmonths),
            yaxis = collect(1:nplants), color = :PuRd, aspect_ratio = 1)    
        plot6 = plot(plot2, plot3, plot4, plot5, layout = (2, 2), link = :y)
        return plot1, plot6
    else
        plot6 = plot(plot2, plot3, layout = (1, 2), link = :y)
        return plot1, plot6
    end
end;