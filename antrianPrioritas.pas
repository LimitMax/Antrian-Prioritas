program antrianPrioritas;
uses crt,MMSystem, sysutils;

type
  TInfo = record
    antrian : String[8];
  end;
  PData = ^TData;

  TData = record
    info: TInfo;
    Next: PData;
  end;

var
  awal, akhir: PData;
  pilihan: integer;
  penghitung : integer;
  meja1 : TInfo;
  meja2 : TInfo;
  banyak_data : integer;

//mendapatkan posisi anak kiri dari nomor_antrian
function anakKiri(nomor_antrian : integer): integer;
begin
  anakKiri := nomor_antrian * 2;
end;

//untuk mendapatkan posisi anak kanan dari nomor_antrian
function anakKanan(nomor_antrian : integer): integer;
begin
  anakKanan := nomor_antrian * 2 + 1;
end;

//untuk mendapatkan posisi parent dari nomor_antrian
function parent(nomor_antrian : integer): integer;
begin
  parent := nomor_antrian div 2;
end;

//mencari data pada posisi ke n
function ambilNilaiDariHeap(n : integer) : PData;
var 
  bantu : PData;
  posisi : integer;
begin
  bantu := awal;
  posisi := 1;
  while (bantu <> akhir) and (posisi <> n) do
  begin
    bantu := bantu^.next;
    posisi := posisi + 1;
  end;  
  ambilNilaiDariHeap := bantu;
end;

//menukar data dalam heap
procedure tukar(nomor_antrian1:integer ;nomor_antrian2:integer);
var
  temp:TInfo;
begin
   temp := ambilNilaiDariHeap(nomor_antrian1)^.info;
   ambilNilaiDariHeap(nomor_antrian1)^.info := ambilNilaiDariHeap(nomor_antrian2)^.info;
   ambilNilaiDariHeap(nomor_antrian2)^.info := temp;
end;

//penambahan data geser_ke_atas = shift_up
procedure geser_ke_atas() ;
var
  nomor_antrian : integer;
begin
  nomor_antrian := banyak_data;
  while(nomor_antrian > 1) and ( ambilNilaiDariHeap(parent(nomor_antrian))^.info.antrian > ambilNilaiDariHeap(nomor_antrian)^.info.antrian ) do
  begin
    tukar(nomor_antrian, parent(nomor_antrian));
    nomor_antrian := parent(nomor_antrian);
  end;
end;

//reorganisasi untuk membuat ulang heap
procedure buatHeap(nomor_antrian : integer);
begin
  if (ambilNilaiDariHeap(nomor_antrian)^.info.antrian > ambilNilaiDariHeap(anakKiri(nomor_antrian))^.info.antrian) or
     (ambilNilaiDariHeap(nomor_antrian)^.info.antrian > ambilNilaiDariHeap(anakKanan(nomor_antrian))^.info.antrian) then
  begin
    if (ambilNilaiDariHeap(anakKiri(nomor_antrian))^.info.antrian < ambilNilaiDariHeap(anakKanan(nomor_antrian))^.info.antrian ) then
    begin
      tukar(nomor_antrian, anakKiri(nomor_antrian));
      buatHeap(anakKiri(nomor_antrian));
    end
    else
    begin
      tukar(nomor_antrian, anakKanan(nomor_antrian));
      buatHeap(anakKanan(nomor_antrian));
    end;
  end;
end;

//reorganisasi
procedure reorganisasi;
var
  nomor_antrian : integer;
begin
  nomor_antrian := parent(banyak_data);
  while (nomor_antrian >= 1) do
  begin
    buatHeap(nomor_antrian);
    nomor_antrian := nomor_antrian - 1;
  end;
end;

//hapus data antrian
function hapus_antrian() : TInfo;
var
  pHapus : PData;
  info : TInfo;
begin
  info := awal^.info;
  if (awal = akhir) then
  begin
    Dispose(awal);
    awal := nil;
    akhir := nil;
  end
  else
  begin
    pHapus := awal;
    awal := awal^.Next;
    Dispose(pHapus);
  end;
  banyak_data := banyak_data - 1;
  hapus_antrian := info;
end;

//sisip_belakang hanya dipanggil oleh prosedure ambilAntrianBisnis dan ambilAntrianPersonal dan hanya buat menyispkan data pada belakang linkedlist
procedure sisip_belakang( i:String; var awal, akhir:PData );
var
  baru:PData;
  begin
      new(baru);
      baru^.info.antrian :=i;
      baru^.next:=nil;
      if (awal=nil) then
          awal:=baru
      else  
        akhir^.next:=baru;
        akhir:=baru;
end;

//ambil antrian baru jenis bisnis
procedure ambilAntrianBisnis();
var
  info : TInfo;
begin
  ClrScr;
  penghitung := penghitung + 1;
  banyak_data := banyak_data + 1;
  info.antrian := 'B'+IntToStr(penghitung);
  sisip_belakang(info.antrian, awal, akhir);
  geser_ke_atas();
  WriteLn('Nomor antrian anda : ', info.antrian);
  WriteLn('Tekan enter untuk melanjutkan.');
  readln();
end;

//ambil antrian baru personal
procedure ambilAntrianPersonal();
var
  info : TInfo;
begin
  ClrScr;
  penghitung := penghitung + 1;
  banyak_data := banyak_data + 1;
  info.antrian := 'P'+IntToStr(penghitung);
  sisip_belakang(info.antrian, awal, akhir);
  geser_ke_atas();
  WriteLn('Nomor antrian anda : ', info.antrian);
  WriteLn('Tekan enter untuk melanjutkan.');
  readln();
end;

//mengecek apakah antrian kosong atau tidak
function kosong():boolean;
begin
  if awal = nil then
    kosong := true
    else
    kosong := false;
end;

//Memanggil suara
procedure playsound(namafile: string);
var
   Pnamafile: PChar;
begin
     Pnamafile :=StrAlloc(length(namafile));
     Pnamafile :=StrPCopy(Pnamafile, namafile);
     sndPlaySound(Pnamafile, snd_sync);
end;

//memamnggil antrian di meja 1
procedure panggilKeMeja1();
var
  i : integer;
  namafile : String;
begin
  ClrScr;
  if kosong = true then
  begin
    WriteLn('Antrian Kosong ');
  end
  else
  begin
    meja1 := hapus_antrian;
    reorganisasi;
    Writeln('Nomor Antrian ',meja1.antrian,' Ke Meja satu' );
    playsound('C:\Dev-Pas\project\suara\nomor-antrian.wav');
    if meja1.antrian[1]='B' then
      playsound('C:\Dev-Pas\project\suara\b.wav')
    else
      playsound('C:\Dev-Pas\project\suara\p.wav');
    
    for i:= 2 to length(meja1.antrian)do
    begin 
      namafile:= 'C:\Dev-Pas\project\suara\' +meja1.antrian[i]+'.wav';
      playsound(namafile);
    end;
    playsound('C:\Dev-Pas\project\suara\meja1.wav');
    end;
    Writeln('Tekan Enter Untuk Melanjutkan ');
    ReadLn();
end;

//Memamnggil antrian di meja 2
procedure panggilKeMeja2();
var 
  i : integer;
  namafile : String;

begin
  ClrScr;
  if kosong = true then
  begin
    WriteLn('Antrian Kosong ');
  end
  else
  begin
    meja2 := hapus_antrian;
    reorganisasi;
    WriteLn('Nomor Antrian ',meja2.antrian,' Ke Meja Dua' );
    playsound('C:\Dev-Pas\project\suara\nomor-antrian.wav');
    if meja2.antrian[1]='B' then
      playsound('C:\Dev-Pas\project\suara\b.wav')
    else
      playsound('C:\Dev-Pas\project\suara\p.wav');
    
    for i:= 2 to length(meja2.antrian)do
    begin 
    namafile:='C:\Dev-Pas\project\suara\'+meja2.antrian[i]+'.wav';
      playsound(namafile);
    end;
    playsound('C:\Dev-Pas\project\suara\meja2.wav');
    end;
    WriteLn('Tekan Enter Untuk Melanjutkan ');
    ReadLn();
end;

//Menu
function tampilMenu() : integer;
var
  pilihan : integer;
begin
    ClrScr;
    WriteLn('======= PROGRAM ANTRIAN BANK =======');
    writeLn('');
    writeLn('==============    =============');
    writeLn('||  Meja 1  ||    ||  Meja 2 ||');
    writeLn('==============    =============');
    Write('||    ', meja1.antrian,'    ||    ||    ', meja2.antrian,'   ||');
    writeLn('');
    writeLn('==============    =============');
    writeLn('');
    writeLn('-------------------------------');
    if (awal <> nil) then WriteLn('Nomor Selanjutnya : ', awal^.info.antrian);
    writeLn('-------------------------------');
    writeLn('');
    WriteLn('1. Tambah Antrian Bisnis');
    WriteLn('2. Tambah Antrian personal');
    WriteLn('3. Meja 1 Memanggil');
    WriteLn('4. Meja 2 Memanggil');
    WriteLn('5. Keluar Aplikasi');
    Write('Pilihan Anda : ');
    ReadLn(pilihan);
    tampilMenu := pilihan;
end;

//main
begin
  banyak_data := 0;
  // inisialisasi linked list
  awal := nil;
  akhir := nil;
  // memberikan tanda '--' pada antrian kosong
  meja1.antrian := '--';
  meja2.antrian := '--';
  repeat
    pilihan := tampilMenu();
    case(pilihan) of 
      1 : ambilAntrianBisnis;
      2 : ambilAntrianPersonal;
      3 : panggilKeMeja1;
      4 : panggilKeMeja2;
    end;
  until pilihan = 5
end.
