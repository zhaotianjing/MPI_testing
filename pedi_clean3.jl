miss_vec = [" ","0",""] 
function quality_control(file,miss_vec; delim = ',', header = 0)
    """
    Zigui Section
    Remove duplicates
    Example: a8  a4  a6
             a8  a4  a6
    Return:  a8  a4  a6
    
    Find row that misses son
    Example:    a4  a6 
             
    Find son that misses both sire and dam
    Example: a5  
    """
    
    
    dat = CSV.read("pedigree_clean.txt", delim = ",", header = 1,missingstrings = miss_vec)
    #Potential risk, now read nothing will return "" instead of missing
    
    dat = unique!(dat) #remove duplicate
    miss_son_row=ismissing.(dat[:,1])  #find the row that miss son
    miss_par_row = (ismissing.(dat[:,2]).|ismissing.(dat[:,3])) #Find the row that miss both sire and dam
    miss_son_index = findall(miss_son_row)
    miss_par_index = findall(miss_par_row)
    miss_par_son = dat[miss_par,1]
    if sum(miss_son_row) >0 @warn "Find missing son record at row $miss_son_index" end
    if sum(miss_par_row) >0 @warn "Find son $miss_par_son that miss parents at row $miss_par_index" end
   
    println("Zigui section finish")
    
    dropmissing!(dat) #Remove all rows containing missing value (Do it for following code can be run)
    
    """
    Jiayi Section
    Remove individuals that are both parents and children
    Input: 
    a5	a9	a7
    a6	a5	a4
    a7	a7	a8
    a9	a5	a4
    
    Output: 
    a5	a9	a7
    a6	a5	a4
    a9	a5	a4

    """
    index = collect(1:1:nrow(dat)) 
    
    ConflictRole = index[dat[1] .== dat[2]]
    append!(ConflictRole, index[dat[1] .== dat[3]])
    Ind = String.(dat[ConflictRole, 1])  
    deleterows!(dat, ConflictRole)
    
    if !isempty(ConflictRole)
        @warn "Conflict Role observed for individual $Ind"
    end
    
    println("Jiayi section finish")
    
    
    """
    Tianjing Section
    Goal:    warn duplicate son (this step is after removing all duplicate)
    Example: a4 a1 a2
             a4 a9 a10
             a4 a6 a2
    """
    root_signal = "0"
    dup_bool = nonunique(dat, 1)
    dup_son = unique(dat[1][dup_bool])
    #warning
    index_dup_son = findall(x -> x in dup_son, dat[1])
    dup_data = dat[index,:]
    @warn "Same son with different parents in row $index_dup_son
    $dup_data"
    
    
    """
    Goal:    warn element in both dam and sire
    Example: a8  a4 a6
             a9  a4 a6
             a13 a6 a2
    """
    dup = intersect(dat[2], dat[3])
    filter!(e -> e ≠ root_signal, dup)  #remove the dam and sire of root, eg. "0"
    dup_both = vcat(findall(x->x in dup, dat[2]),findall(x->x in dup, dat[3])) #find index of dup
    #warning
    unique!(dup_both)
    sort!(dup_both)
    dup_dat= dat[dup_both,:]
    @warn "Parents in row $dup_both appear in both dam and sire
    $dup_dat"
    
    println("Tianjing section finish")
    return dat
    
end
        
#Testing
quality_control("pedigree_clean.txt",miss_vec)
