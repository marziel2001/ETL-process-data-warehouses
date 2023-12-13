USE szkolaJazdyHD;
go

Declare @StartDate date;
Declare @EndDate date;

SELECT @StartDate = '2023-01-01', @EndDate = '2023-12-31';

Declare @DateInProcess datetime = @StartDate;

While @DateInProcess <= @EndDate
	Begin
		Insert into [dbo].[Date]
		( [Day]
		, [Month]
		, [Year]
		, [Holiday]
		)
		Values (
			CAST(Day(@DateInProcess) as int)
			, CAST(Month(@DateInProcess) as int)
			, CAST(Year(@DateInProcess) as int)
			, CASE WHEN MONTH(@DateInProcess) IN (7, 8) THEN 'holiday' ELSE 'non-holiday' END
		);

		Set @DateInProcess = DATEADD(d, 1, @DateInProcess);
	End
go

Select * from [dbo].[Date]