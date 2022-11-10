const std = @import("std");
const testing = std.testing;
const allocator= std.heap.page_allocator;
pub const Dtype= enum {int, float, bool, string};
const Cell= union(Dtype){
    int: i64,
    float:f64,
    bool: bool,
    string: []const u8,
};
const Column= struct{
    Row:[]Cell=undefined,
    title:[]const u8,
    size:u64=undefined,
    usage:u64=0,
    ctype:Dtype=Dtype.int,
};
pub const DataFrame= struct{
    columns:std.StringHashMap(Column),
    size:u64,
    pub fn addColumn(self: *DataFrame,ctype:Dtype, title: []const u8) void{
        self.size+=1;
        var nc= newcolumn(title,ctype);
        self.columns.put(title, nc) catch @panic("Hash map failed");
    }
    pub fn getColumn(self: *DataFrame,title:[]const u8) []Cell{ 
        var column = self.columns.get(title).?;
        return column.Row;
    }
};
pub fn newdf() DataFrame{
    return DataFrame{.columns=std.StringHashMap(Column).init(allocator), .size=0};
}
fn newcolumn(title:[]const u8, dtype:Dtype) Column{
    var nc:Column=Column{.size=20,.usage=0,.title=title, .ctype=dtype};
    nc.Row = allocator.alloc(Cell, 20) catch undefined;
    return nc;
}
pub fn main() void{ 
    var df1:DataFrame= newdf();
    df1.addColumn(Dtype.int,"HI");
}
test "basic add functionality" {
    var df1:DataFrame = newdf();    
    df1.addColumn(Dtype.int,"HI");
    var column:[] Cell=df1.getColumn("HI");
    column[2]=Cell{.int=8};
}

