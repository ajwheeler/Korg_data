using CSV, HDF5, DataFrames, Korg

most_common_isotopes = Dict()
for (Z, isotopes) in Korg.isotopic_abundances
    most_common_isotopes[Z] = last(sort(collect(keys(isotopes)), by=w->isotopes[w]))
end

archive_file = "polyatomic_partition_funcs.h5"

for filename in readdir("partition_funcs/")
    isotopologue = filename[1:end-3]
    r = r"\((?<weight>\d+)(?<element>\p{L}+)\)(?<multiplicity>\d?)"
    isotopes = collect(eachmatch(r, isotopologue))
    multiplicities = map(isotopes) do isotope
        if isotope["multiplicity"] == ""
            1
        else
            parse(Int, isotope["multiplicity"])
        end
    end
    n_atoms = sum(multiplicities)
    all_common = map(isotopes) do isotope
        most_common_isotopes[Korg.atomic_numbers[isotope["element"]]] == parse(Int, isotope["weight"])
    end |> all
    # we only want polyatomic atoms without cis/trans specification in which all nuclei are the most abundant isotope of their element
    if n_atoms <= 2 || isotopologue[1] != '(' || !all_common
        continue
    end
    
    formula = Korg.Formula(*([*([isotope["element"] for _ in 1:m]...) for (isotope, m) in zip(isotopes, multiplicities)]...))
    charge = if isotopologue[end] == '+'
        1
    else
        0
    end
    spec = Korg.Species(formula, charge)

    Udata = CSV.read(joinpath("partition_funcs", filename), DataFrame, delim=' ', ignorerepeated=true, header=["T", "U"])
    h5write(archive_file, "$(spec)/temp", Udata.T)
    h5write(archive_file, "$(spec)/partition_function", Udata.U)
end
