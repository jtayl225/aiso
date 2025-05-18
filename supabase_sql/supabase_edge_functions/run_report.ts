import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {

  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405 });
  }
  
  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const fastapiUrl = Deno.env.get("FASTAPI_URL")!; // e.g. https://your-api.com/ai-search

  const supabase = createClient(supabaseUrl, supabaseKey);

  const { reportId } = await req.json();

  if (!reportId) {
    return new Response("Missing reportId", { status: 400 });
  }

  // Create a new report_run record with status 'running'
  const { data: runData, error: runError } = await supabase
    .from("report_runs")
    .insert({
      report_id: reportId,
      status: "running",
      started_at: new Date().toISOString(),
    })
    .select()
    .single();

  if (runError || !runData) {
    return new Response(`Error creating report run: ${runError?.message}`, { status: 500 });
  }

  const runId = runData.id;

  try {
    // Fetch report target info
    const { data: reportData, error: reportError } = await supabase
      .from("reports")
      .select("id")
      .eq("id", reportId)
      .single();

    if (reportError || !reportData) {
      throw new Error("Report not found");
    }

    // Fetch search target
    const { data: searchTarget, error: searchTargetError } = await supabase
      .from("search_target")
      .select("type, name, description, url")
      .eq("report_id", reportId)
      .single();

    if (searchTargetError || !searchTarget) {
      throw new Error("No search target found");
    }

    // Fetch prompts
    const { data: prompts, error: promptsError } = await supabase
      .from("prompts")
      .select("id as promptId, formatted_prompt as prompt")
      .eq("report_id", reportId);

    if (promptsError || !prompts?.length) {
      throw new Error("No prompts found");
    }

    const payload = {
      reportId: reportData.id,
      searchTarget: {
        type: searchTarget.type,
        name: searchTarget.name,
        description: searchTarget.description,
        url: searchTarget.url,
      },
      prompts: prompts,
    };

    // Call FastAPI
    const response = await fetch(fastapiUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`FastAPI error: ${errorText}`);
    }

    const fastApiData = await response.json();

    // Insert report_results rows
    // Each searchResult corresponds to a prompt result
    // Use the llm enum type and store full result JSON per row
    const resultsToInsert = fastApiData.searchResults.map((res: any) => ({
      run_id: runId,
      report_id: reportId,
      prompt_id: res.promptId,
      llm: res.llm,
      result_json: res, // store entire result object as JSONB
      search_target_found: res.search_target_found,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    }));

    const { error: insertError } = await supabase
      .from("report_results")
      .insert(resultsToInsert);

    if (insertError) {
      throw new Error(`Error saving report results: ${insertError.message}`);
    }

    // Update report_runs with status 'completed'
    await supabase
      .from("report_runs")
      .update({
        finished_at: new Date().toISOString(),
        status: "completed",
        updated_at: new Date().toISOString(),
      })
      .eq("id", runId);

    return new Response(JSON.stringify({ success: true }), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });

  } catch (error) {
    // Update report_runs with status 'failed' and error message
    await supabase
      .from("report_runs")
      .update({
        finished_at: new Date().toISOString(),
        status: "failed",
        error_message: (error as Error).message,
        updated_at: new Date().toISOString(),
      })
      .eq("id", runId);

    return new Response(JSON.stringify({ success: false, error: error.message }), {
      headers: { "Content-Type": "application/json" },
      status: 500,
    });
  }
});
