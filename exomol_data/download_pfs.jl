using Downloads: download
using CSV, DataFrames, HTTP, JSON, Revise, Korg

# keep track of the dataset/paper for each isotopologue
datasets = []

lines = filter(readlines("exomol.all")) do line
    endswith(line, "Molecule chemical formula")
end
molecular_formulas = first.(split.(lines))
for molecular_formula in molecular_formulas
    # skip molecule if species parsing errors
    spec = Korg.Species(molecular_formula)

    url = "https://exomol.com/api/?molecule=$(replace(molecular_formula, "+"=>"_p"))&datatype=partitionfunction"
    json = JSON.parse(String(HTTP.get(url).body))
    
    for (isotop, isodata) in json
        recdata = filter(collect(isodata["partitionfunction"])) do (dataset, props)
            if dataset == "data type"
                false
            else
                props["recommended"]
            end
        end 
        if recdata != []
            files = recdata[1].second["files"]
            # sometimes the list of files doesn't actually include a .pf file
            # see https://github.com/ExoMol/exomol.com/issues/14
            filter!(files) do f
                endswith(f["url"], ".pf")
            end 
            if length(files) != 0
                url = first(files)["url"]
                download(url, "partition_funcs/$(isotop).pf")
                push!(datasets, (isotop, recdata[1].first))
            end
        end
    end
end

df = DataFrame(isotopologue=first.(datasets), dataset=last.(datasets))
CSV.write("data_sources.csv", df)
