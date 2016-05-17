unit UserScript;

uses 'lib\mxpf';

function Initialize: Integer;
var 
	i: integer;
	rec: IInterface;
	x, y: string;
	sl: TStringList;
begin
	InitializeMXPF;
	DefaultOptionsMXPF;
	LoadChildRecords('WRLD', 'CELL');
	
	sl := TStringList.Create;
	sl.Add('"string" :');
	sl.Add('{');
	
	for i := 0 to MaxRecordIndex do begin
	
		rec := GetRecord(i);
		if String (geev(rec, 'Worldspace')) = 'Tamriel "Skyrim" [WRLD:0000003C]' then
			sl.Add('	"' + geev(rec, 'XCLC/X') + ':' + geev(rec, 'XCLC/Y') + '" : "' + IntToHex(FixedFormID(rec), 8) + '",');
		
	end;
	
	sl.Add('}');
	
	PrintMXPFReport;
	FinalizeMXPF;
	sl.SaveToFile('test.txt');
	sl.Free;
	
end;

end.